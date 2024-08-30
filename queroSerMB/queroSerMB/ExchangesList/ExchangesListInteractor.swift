//
//  ExchangesListInteractor.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import Foundation

// MARK: - Protocols
protocol ExchangesListInteractorProtocol: AnyObject {
    func callServices()
    func filterExchanges(with text: String)
    func showDetails(indexPath: IndexPath)
}

// MARK: - Main Class
final class ExchangesListInteractor {
    
    // MARK: - Private Properties
    private(set) var exchanges: [ExchangeModel] = []
    private var exchangesLogos: [ExchangeLogoModel] = []
    private let presenter: ExchangesListPresenterProtocol
    private let service: NetworkServiceProtocol
    
    // MARK: - Initializer
    init(presenter: ExchangesListPresenterProtocol,
         service: NetworkServiceProtocol) {
        self.presenter = presenter
        self.service = service
    }
}

// MARK: - ExchangesListInteractorProtocol
extension ExchangesListInteractor: ExchangesListInteractorProtocol {
    func callServices() {
        fetchExchanges { [weak self] in
            self?.fetchExchangeLogos(completion: {
                self?.presenter.showList(exchanges: self?.exchanges ?? [], exchangesLogo: self?.exchangesLogos ?? [])
            })
        }
    }
    
    func filterExchanges(with text: String) {
        let filteredExchanges = text.isEmpty ? exchanges : exchanges.filter { exchange in
            let searchText = text.lowercased()
            let matchesName = exchange.name?.lowercased().contains(searchText) ?? false
            let matchesExchangeId = exchange.exchangeId?.lowercased().contains(searchText) ?? false
            return matchesName || matchesExchangeId
        }
        presenter.showList(exchanges: filteredExchanges, exchangesLogo: exchangesLogos)
    }
    
    func showDetails(indexPath: IndexPath) {
        let exchange = exchanges[indexPath.section]
        guard let exchangeId = exchange.exchangeId else {
            print("Exchange ID not found for given indexPath")
            return
        }
        
        let logoModel = exchangesLogos.first(where: { $0.exchangeId == exchangeId }) ??
                        ExchangeLogoModel(exchangeId: exchange.exchangeId, url: nil)
        
        presenter.showDetails(exchanges: exchange, exchangesLogo: logoModel)
    }
}

// MARK: - Private Helpers
private extension ExchangesListInteractor {
    func fetchExchanges(completion: @escaping () -> Void) {
        service.getExchangeList { [weak self] result in
            switch result {
            case .success(let fetchedExchanges):
                self?.exchanges = fetchedExchanges
                completion()
            case .failure:
                self?.presenter.showError()
            }
        }
    }
    
    func fetchExchangeLogos(completion: @escaping () -> Void) {
        service.getExchangeLogos { [weak self] result in
            switch result {
            case .success(let fetchedLogos):
                self?.exchangesLogos = fetchedLogos
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

