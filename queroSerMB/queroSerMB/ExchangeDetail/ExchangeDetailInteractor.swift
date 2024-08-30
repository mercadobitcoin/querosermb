//
//  ExchangeDetailInteractor.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import DGCharts
import Foundation

// MARK: - CryptoName Enum
enum CryptoName: Equatable {
    case btc
    case eth
}

// MARK: - Protocols
protocol ExchangeDetailInteractorProtocol: AnyObject {
    func setup()
    func ethGraph()
    func btcGraph()
    func updatePriceValue(data: OHLCVData)
}

// MARK: - Main Class
final class ExchangeDetailInteractor {
    // MARK: - Private Properties
    private let presenter: ExchangeDetailPresenterProtocol
    private let service: NetworkServiceProtocol
    private let exchanges: ExchangeModel
    private let exchangesLogos: ExchangeLogoModel
    private var ohlcvEthData: [OHLCVData] = []
    private var ohlcvBtcData: [OHLCVData] = []
    private var ethDataEntries: [BarChartDataEntry] = []
    private var btcDataEntries: [BarChartDataEntry] = []
    
    // MARK: - Initializer
    init(exchanges: ExchangeModel,
         exchangesLogos: ExchangeLogoModel,
         presenter: ExchangeDetailPresenterProtocol,
         service: NetworkServiceProtocol) {
        self.exchanges = exchanges
        self.exchangesLogos = exchangesLogos
        self.presenter = presenter
        self.service = service
    }
}

// MARK: - ExchangeDetailInteractorProtocol
extension ExchangeDetailInteractor: ExchangeDetailInteractorProtocol {
    func setup() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchData(forCrypto: .eth) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchData(forCrypto: .btc) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let firstBtcData = self.ohlcvBtcData.first {
                self.presenter.updateChartData(data: self.btcDataEntries, priceData: firstBtcData, crypto: .btc)
            } else {
                self.presenter.showError()
            }
            self.presenter.setupLabels(data: self.exchanges, imageData: self.exchangesLogos)
        }

    }
    
    func ethGraph() {
        guard let firstEthData = ohlcvEthData.first else {
            presenter.showError()
            return
        }
        presenter.updateChartData(data: ethDataEntries, priceData: firstEthData, crypto: .eth)
    }

    func btcGraph() {
        guard let firstBtcData = ohlcvBtcData.first else {
            presenter.showError()
            return
        }
        presenter.updateChartData(data: btcDataEntries, priceData: firstBtcData, crypto: .btc)
    }
    
    func updatePriceValue(data: OHLCVData) {
        presenter.updateValue(data: data)
    }
}

// MARK: - Private Helpers
private extension ExchangeDetailInteractor {
    func fetchData(forCrypto crypto: CryptoName, completion: @escaping () -> Void) {
        guard let exchangeId = exchanges.exchangeId else {
            print("Exchange ID is missing.")
            completion()
            return
        }
        
        let asset: String
        switch crypto {
        case .eth: asset = "ETH"
        case .btc: asset = "BTC"
        }
        
        service.getOHLCVForMajorPairs(exchangeId, baseAsset: asset) { [weak self] result in
            defer { completion() }
            
            switch result {
            case .success(let ohlcvData):
                let sortedData = ohlcvData.sorted(by: { $0.timePeriodStart < $1.timePeriodStart })
                var dataEntries: [BarChartDataEntry] = []
                
                for (index, data) in sortedData.enumerated() {
                    if let volume = data.volumeTraded {
                        dataEntries.append(BarChartDataEntry(x: Double(index), y: volume, data: data as AnyObject))
                    }
                }
                
                if crypto == .eth {
                    self?.ohlcvEthData = ohlcvData
                    self?.ethDataEntries = dataEntries
                } else {
                    self?.ohlcvBtcData = ohlcvData
                    self?.btcDataEntries = dataEntries
                }
                
            case .failure(let error):
                print("Error fetching OHLCV data for \(asset): \(error)")
            }
        }
    }
}
