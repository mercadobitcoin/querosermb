//
//  ExchangesListCoordinator.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

protocol ExchangesListCoordinatorProtocol: AnyObject {
    func makeDetailsScene(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel)
}

final class ExchangesListCoordinator {
    weak var viewController: UIViewController?
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ExchangesListCoordinator: ExchangesListCoordinatorProtocol {
    func makeDetailsScene(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {
        let detailScene = ExchangeDetailFactory.make(exchanges: exchanges, exchangesLogos: exchangesLogo)
        navigationController.pushViewController(detailScene, animated: true)
    }
}
