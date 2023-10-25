//
//  ExchangeListProtocolsMock.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import Foundation
@testable import queroSerMB

class MockExchangesListViewController: ExchangesListViewControllerProtocol {
    var exchangeListReceived: [ExchangeCellViewModel]?
    var displayListCalled = false
    
    func displayList(exchangeList: [ExchangeCellViewModel]) {
        exchangeListReceived = exchangeList
        displayListCalled = true
    }
}

class MockExchangesListInteractor: ExchangesListInteractorProtocol {
    var servicesCalled = false
    var exchangesFiltered = false
    var detailsRequested = false
    
    func callServices() {
        servicesCalled = true
    }
    
    func getExchangeList() -> [ExchangeModel] {
        return []
    }
    
    func filterExchanges(with text: String) {
        exchangesFiltered = true
    }
    
    func showDetails(indexPath: IndexPath) {
        detailsRequested = true
    }
}

class MockExchangesListPresenter: ExchangesListPresenterProtocol {
    var exchangesShown: [ExchangeModel]?
    var exchangesLogoShown: [ExchangeLogoModel]?
    var showListCalled = false
    
    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel]) {
        exchangesShown = exchanges
        exchangesLogoShown = exchangesLogo
        showListCalled = true
    }
    func showDetails(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {}
}

class MockExchangesListCoordinator: ExchangesListCoordinatorProtocol {
    var didNavigateToDetails = false
    func navigateToDetailsScene(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {
        didNavigateToDetails = true
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var getExchangeListCalled = false
    var getExchangeLogosCalled = false
    var getExchangeListCompletion: (() -> Void)?
    var getExchangeLogosCompletion: (() -> Void)?
    
    func getExchangeList(completion: @escaping (Result<[ExchangeModel], Error>) -> Void) {
        getExchangeListCalled = true
        completion(.success([]))
        getExchangeListCompletion?()
    }
    
    func getExchangeLogos(completion: @escaping (Result<[ExchangeLogoModel], Error>) -> Void) {
        getExchangeLogosCalled = true
        completion(.success([]))
        getExchangeLogosCompletion?()
    }
    
    func getOHLCVForMajorPairs(_ exchangeId: String, baseAsset: String, completion: @escaping (Result<[queroSerMB.OHLCVData], Error>) -> Void) {}
}
