//
//  ExchangeDetailInteractor.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import DGCharts
import Foundation

enum CryptoName {
    case btc
    case eth
}

protocol ExchangeDetailInteractorProtocol: AnyObject {
    func setup()
    func ethGraph()
    func btcGraph()
    func updatePriceValue(data: OHLCVData)
}

final class ExchangeDetailInteractor {
    private var exchanges: ExchangeModel
    private var exchangesLogos: ExchangeLogoModel
    private var ohlcvEthData: [OHLCVData] = []
    private var ohlcvBtcData: [OHLCVData] = []
    private var ethDataEntries: [BarChartDataEntry] = []
    private var btcDataEntries: [BarChartDataEntry] = []
    private let presenter: ExchangeDetailPresenterProtocol
    private let service: NetworkServiceProtocol
    
    init(exchanges: ExchangeModel,
         exchangesLogos: ExchangeLogoModel,
         presenter: ExchangeDetailPresenterProtocol, service: NetworkServiceProtocol) {
        self.exchanges = exchanges
        self.exchangesLogos = exchangesLogos
        self.presenter = presenter
        self.service = service
    }
}

extension ExchangeDetailInteractor: ExchangeDetailInteractorProtocol {
    func setup() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getETHData() {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getBTCData() {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.presenter.updateChartData(data: self.btcDataEntries, priceData: self.ohlcvBtcData[0], crypto: .btc)
            self.presenter.setupLabels(data: self.exchanges, imageData: self.exchangesLogos)
        }
    }
    
    func ethGraph() {
        self.presenter.updateChartData(data: self.ethDataEntries, priceData: self.ohlcvEthData[0], crypto: .eth)
    }
    
    func btcGraph() {
        self.presenter.updateChartData(data: self.btcDataEntries, priceData: self.ohlcvBtcData[0], crypto: .btc)
    }
    
    func updatePriceValue(data: OHLCVData) {
        presenter.updateValue(data: data)
    }
}

private extension ExchangeDetailInteractor {
    func getETHData(completion: @escaping () -> Void) {
        service.getOHLCVForMajorPairs(exchanges.exchangeId ?? "", baseAsset: "ETH") { [weak self] result in
            defer { completion() }
            switch result {
            case .success(let ohlcvData):
                self?.ohlcvEthData = ohlcvData
                let sortedData = ohlcvData.sorted(by: { $0.timePeriodStart < $1.timePeriodStart })
                
                for (index, data) in sortedData.enumerated() {
                    if let volume = data.volumeTraded {
                        self?.ethDataEntries.append(BarChartDataEntry(x: Double(index), y: volume, data: data as AnyObject))
                    }
                }
                
            case .failure(let error):
                print("Error fetching OHLCV data: \(error)")
            }
        }
    }
    
    func getBTCData(completion: @escaping () -> Void) {
        service.getOHLCVForMajorPairs(exchanges.exchangeId ?? "", baseAsset: "BTC") { [weak self] result in
            defer { completion() }
            switch result {
            case .success(let ohlcvData):
                self?.ohlcvBtcData = ohlcvData
                let sortedData = ohlcvData.sorted(by: { $0.timePeriodStart < $1.timePeriodStart })
                
                for (index, data) in sortedData.enumerated() {
                    if let volume = data.volumeTraded {
                        self?.btcDataEntries.append(BarChartDataEntry(x: Double(index), y: volume, data: data as AnyObject))
                    }
                }
                
            case .failure(let error):
                print("Error fetching OHLCV data: \(error)")
            }
        }
    }
}
