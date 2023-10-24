//
//  ExchangesListInteractor.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import Foundation

protocol ExchangesListInteractorProtocol: AnyObject {
    func callServices()
    func getExchangeList() -> [ExchangeModel]
    func filterExchanges(with text: String)
    func showDetails(indexPath: IndexPath)
}

final class ExchangesListInteractor {
    private var exchanges: [ExchangeModel] = []
    private var exchangesLogos: [ExchangeLogoModel] = []
    private let presenter: ExchangesListPresenterProtocol
    private let service: NetworkServiceProtocol
    
    init(presenter: ExchangesListPresenterProtocol,
         service: NetworkServiceProtocol) {
        self.presenter = presenter
        self.service = service
    }
}

extension ExchangesListInteractor: ExchangesListInteractorProtocol {
    func callServices() {
        let group = DispatchGroup()
        
        group.enter()
        service.getExchangeList { result in
            switch result {
            case .success(let exchanges):
                self.exchanges = exchanges
                group.enter()
                self.service.getExchangeLogos { logoResult in
                    switch logoResult {
                    case .success(let logos):
                        self.exchangesLogos = logos
                    case .failure(let logoError):
                        print(logoError)
                    }
                    group.leave()
                }
                
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.presenter.showList(exchanges: self.exchanges, exchangesLogo: self.exchangesLogos)
        }
    }

    func getExchangeList() -> [ExchangeModel] {
        exchanges
    }
    
    func filterExchanges(with text: String) {
        if text.isEmpty {
            self.presenter.showList(exchanges: self.exchanges, exchangesLogo: self.exchangesLogos)
        } else {
            let filtered = exchanges.filter { exchange in
                let matchesName = exchange.name?.lowercased().contains(text.lowercased()) ?? false
                let matchesExchangeId = exchange.exchangeId?.lowercased().contains(text.lowercased()) ?? false
                
                return matchesName || matchesExchangeId
            }
            self.presenter.showList(exchanges: filtered, exchangesLogo: self.exchangesLogos)
        }
    }
    
    func showDetails(indexPath: IndexPath) {
        let exchange = self.exchanges[indexPath.section]
        guard let exchangeId = exchange.exchangeId else {
            print("Exchange ID not found for given indexPath")
            return
        }
        
        if let logoModel = self.exchangesLogos.first(where: { $0.exchangeId == exchangeId }) {
            presenter.showDetails(exchanges: exchange, exchangesLogo: logoModel)
        } else {
            presenter.showDetails(exchanges: exchange, exchangesLogo: ExchangeLogoModel(exchangeId: exchange.exchangeId, url: nil))
        }
    }

}
