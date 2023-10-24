//
//  ExchangesListPresenter.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import Foundation

// MARK: - Protocols
protocol ExchangesListPresenterProtocol: AnyObject {
    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel])
    func showDetails(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel)
}

// MARK: - Main Class
final class ExchangesListPresenter {
    
    // MARK: - Properties
    private let coordinator: ExchangesListCoordinatorProtocol
    weak var viewController: ExchangesListViewControllerProtocol?
    
    // MARK: - Initializer
    init(coordinator: ExchangesListCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

// MARK: - ExchangesListPresenterProtocol
extension ExchangesListPresenter: ExchangesListPresenterProtocol {
    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel]) {
        let viewModels = exchanges.map { exchange in
            mapExchangeToViewModel(exchange: exchange, logos: exchangesLogo)
        }
        viewController?.displayList(exchangeList: viewModels)
    }

    func showDetails(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {
        coordinator.navigateToDetailsScene(exchanges: exchanges, exchangesLogo: exchangesLogo)
    }
}

// MARK: - Private Helpers
private extension ExchangesListPresenter {
    func mapExchangeToViewModel(exchange: ExchangeModel, logos: [ExchangeLogoModel]) -> ExchangeCellViewModel {
        let logoUrl = logos.first(where: { $0.exchangeId == exchange.exchangeId })?.url
        return ExchangeCellViewModel(from: exchange, logoUrl: logoUrl)
    }
}

