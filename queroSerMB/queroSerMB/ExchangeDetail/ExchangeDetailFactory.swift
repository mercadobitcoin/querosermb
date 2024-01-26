//
//  ExchangeDetailFactory.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import Foundation

enum ExchangeDetailFactory {
    static func make(exchanges: ExchangeModel,
                     exchangesLogos: ExchangeLogoModel) -> ExchangeDetailViewController {
        let presenter = ExchangeDetailPresenter()
        let service: NetworkServiceProtocol = NetworkService()
        let interactor = ExchangeDetailInteractor(exchanges: exchanges,
                                                  exchangesLogos: exchangesLogos,
                                                  presenter: presenter,
                                                  service: service)
        let viewController = ExchangeDetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
