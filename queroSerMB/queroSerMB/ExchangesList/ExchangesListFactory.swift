//
//  ExchangesListFactory.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

enum ExchangesListFactory {
    static func make() -> ExchangesListViewController {
        let coordinator = ExchangesListCoordinator()
        let presenter = ExchangesListPresenter(coordinator: coordinator)
        let service: NetworkServiceProtocol = NetworkService()
        let interactor = ExchangesListInteractor(presenter: presenter, service: service)
        let viewController = ExchangesListViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
