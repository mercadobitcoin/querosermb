//
//  ExchangeDetailInteractor.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import DGCharts
import Foundation

protocol ExchangeDetailInteractorProtocol: AnyObject {
    func setup()
}

final class ExchangeDetailInteractor {
    private var exchanges: ExchangeModel
    private var exchangesLogos: ExchangeLogoModel
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
        
        // Fetch ETH Data
        dispatchGroup.enter()
        getETHData() {
            dispatchGroup.leave()
        }
        
        // Fetch BTC Data
        dispatchGroup.enter()
        getBTCData() {
            dispatchGroup.leave()
        }
        
        // Notify once both ETH and BTC data have been fetched
        dispatchGroup.notify(queue: .main) {
            // Call the presenter method here
            self.presenter.updateChartData(ethData: self.ethDataEntries, btcData: self.btcDataEntries)
        }
    }
}

private extension ExchangeDetailInteractor {
    func getETHData(completion: @escaping () -> Void) {
        service.getOHLCVForMajorPairs(exchanges.exchangeId ?? "", baseAsset: "ETH") { [weak self] result in
            defer { completion() } // Ensure that the completion block is called no matter what
            switch result {
            case .success(let ohlcvData):
                let sortedData = ohlcvData.sorted(by: { $0.timePeriodStart < $1.timePeriodStart })
                
                for (index, data) in sortedData.enumerated() {
                    if let volume = data.volumeTraded {
                        self?.ethDataEntries.append(BarChartDataEntry(x: Double(index), y: volume, data: "ETH" as AnyObject))
                    }
                }
                
            case .failure(let error):
                print("Error fetching OHLCV data: \(error)")
            }
        }
    }
    
    func getBTCData(completion: @escaping () -> Void) {
        service.getOHLCVForMajorPairs(exchanges.exchangeId ?? "", baseAsset: "BTC") { [weak self] result in
            defer { completion() } // Ensure that the completion block is called no matter what
            switch result {
            case .success(let ohlcvData):
                let sortedData = ohlcvData.sorted(by: { $0.timePeriodStart < $1.timePeriodStart })
                
                for (index, data) in sortedData.enumerated() {
                    if let volume = data.volumeTraded {
                        self?.btcDataEntries.append(BarChartDataEntry(x: Double(index), y: volume, data: "BTC" as AnyObject))
                    }
                }
                
            case .failure(let error):
                print("Error fetching OHLCV data: \(error)")
            }
        }
    }
}
