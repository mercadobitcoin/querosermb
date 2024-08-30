//
//  ExchangesListCoordinator.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

// MARK: - Protocols
protocol ExchangesListCoordinatorProtocol: AnyObject {
    func navigateToDetailsScene(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel)
}

// MARK: - Main Class
final class ExchangesListCoordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    weak var viewController: UIViewController?
    
    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - ExchangesListCoordinatorProtocol
extension ExchangesListCoordinator: ExchangesListCoordinatorProtocol {
    func navigateToDetailsScene(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {
        let detailScene = ExchangeDetailFactory.make(exchanges: exchanges, exchangesLogos: exchangesLogo)
        navigationController.pushViewController(detailScene, animated: true)
    }
}
