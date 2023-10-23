//
//  ExchangesListPresenter.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import Foundation

protocol ExchangesListPresenterProtocol: AnyObject {
    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel])
    func showDetails(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel)
}

final class ExchangesListPresenter {
    private let coordinator: ExchangesListCoordinatorProtocol
    weak var viewController: ExchangesListViewControllerProtocol?
    
    init(coordinator: ExchangesListCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

extension ExchangesListPresenter: ExchangesListPresenterProtocol {
//    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel]) {
//        let viewModels = exchanges.sorted {
//            ($0.dailyVolumeUsd ?? 0) > ($1.dailyVolumeUsd ?? 0)
//        }.map { exchange in
//            let logoUrl = exchangesLogo.first(where: { $0.exchangeId == exchange.exchangeId })?.url
//            return ExchangeCellViewModel(from: exchange, logoUrl: logoUrl)
//        }
//        viewController?.displayList(exchangeList: viewModels)
//    }
    
    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel]) {
        let viewModels = exchanges.map { exchange in
            let logoUrl = exchangesLogo.first(where: { $0.exchangeId == exchange.exchangeId })?.url
            return ExchangeCellViewModel(from: exchange, logoUrl: logoUrl)
        }
        viewController?.displayList(exchangeList: viewModels)
    }

    func showDetails(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {
        coordinator.makeDetailsScene(exchanges: exchanges, exchangesLogo: exchangesLogo)
    }
}
