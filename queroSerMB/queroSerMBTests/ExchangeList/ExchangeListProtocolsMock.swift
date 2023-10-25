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
    var displayErrorCalled = false
    
    func displayList(exchangeList: [ExchangeCellViewModel]) {
        exchangeListReceived = exchangeList
        displayListCalled = true
    }
    
    func displayError() {
        displayErrorCalled = true
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
    var showErrorCalled = false
    var showDetailsCalled = false
    var showListCompletion: (() -> Void)?
    
    func showList(exchanges: [ExchangeModel], exchangesLogo: [ExchangeLogoModel]) {
        exchangesShown = exchanges
        exchangesLogoShown = exchangesLogo
        showListCalled = true
        showListCompletion?()
    }
    
    func showDetails(exchanges: ExchangeModel, exchangesLogo: ExchangeLogoModel) {
        showDetailsCalled = true

    }
    
    func showError() {
        showErrorCalled = true
    }
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
    var getOHLCVForMajorPairsCalled = false
    var getExchangeListCompletion: (() -> Void)?
    var getExchangeLogosCompletion: (() -> Void)?
    var getOHLCVForMajorPairsCompletion: (() -> Void)?
    
    var getExchangeListResult: Result<[ExchangeModel], Error> = .success([])
    var getExchangeLogosResult: Result<[ExchangeLogoModel], Error> = .success([])
    var getOHLCVForMajorPairsResult: Result<[OHLCVData], Error> = .success([])
    
    func getExchangeList(completion: @escaping (Result<[ExchangeModel], Error>) -> Void) {
        getExchangeListCalled = true
        completion(getExchangeListResult)
        getExchangeListCompletion?()
    }

    func getExchangeLogos(completion: @escaping (Result<[ExchangeLogoModel], Error>) -> Void) {
        getExchangeLogosCalled = true
        completion(getExchangeLogosResult)
        getExchangeLogosCompletion?()
    }
    
    func getOHLCVForMajorPairs(_ exchangeId: String, baseAsset: String, completion: @escaping (Result<[queroSerMB.OHLCVData], Error>) -> Void) {
        getOHLCVForMajorPairsCalled = true
        completion(getOHLCVForMajorPairsResult)
        getOHLCVForMajorPairsCompletion?()
    }
}
