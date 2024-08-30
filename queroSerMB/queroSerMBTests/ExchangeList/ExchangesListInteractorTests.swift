//
//  ExchangesListInteractorTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
@testable import queroSerMB

enum MockError: Error {
    case mockError
}

class ExchangesListInteractorTests: XCTestCase {
    var interactor: ExchangesListInteractor!
    var mockService: MockNetworkService!
    var mockPresenter: MockExchangesListPresenter!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        mockPresenter = MockExchangesListPresenter()
        interactor = ExchangesListInteractor(presenter: mockPresenter, service: mockService)
    }

    func testCallServices_WhenGetExchangeListFails_ErrorIsShown() {
        mockService.getExchangeListResult = .failure(MockError.mockError)
        
        interactor.callServices()
        
        XCTAssertTrue(mockPresenter.showErrorCalled)
    }

    func testFilterExchanges_WhenTextIsEmpty_AllExchangesAreReturned() {
        let allExchanges = [
            ExchangeModel(name: "id1", exchangeId: "id1", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0),
            ExchangeModel(name: "id2", exchangeId: "id2", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        ]
        
        mockService.getExchangeListResult = .success(allExchanges)
        
        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")
        
        mockPresenter.showListCompletion = {
            expectation.fulfill()
        }
        
        interactor.callServices()
        
        wait(for: [expectation], timeout: 5.0)
        
        guard let exchangesShown = mockPresenter.exchangesShown else {
            XCTFail("exchangesShown is nil")
            return
        }
        
        XCTAssertTrue(mockPresenter.showListCalled)
        XCTAssertEqual(exchangesShown, allExchanges)
    }


    func testFilterExchanges_WhenFilteredByName_CorrectExchangesAreReturned() {
        let exchange1 = ExchangeModel(name: "Test1", exchangeId: "id1", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let exchange2 = ExchangeModel(name: "Test2", exchangeId: "id2", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let allExchanges = [exchange1, exchange2]
        
        mockService.getExchangeListResult = .success(allExchanges)
        
        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")
        
        mockPresenter.showListCompletion = {
            expectation.fulfill()
        }
        
        interactor.callServices()
        wait(for: [expectation], timeout: 5.0)
        
        interactor.filterExchanges(with: "Test2")
        
        guard let exchangesShown = mockPresenter.exchangesShown else {
            XCTFail("exchangesShown is nil")
            return
        }

        XCTAssertEqual(exchangesShown, [exchange2])
    }

    func testFilterExchanges_WhenFilteredById_CorrectExchangesAreReturned() {
        let exchange1 = ExchangeModel(name: "Test1", exchangeId: "1", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let exchange2 = ExchangeModel(name: "Test2", exchangeId: "2", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let allExchanges = [exchange1, exchange2]

        mockService.getExchangeListResult = .success(allExchanges)

        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")

        mockPresenter.showListCompletion = {
            expectation.fulfill()
        }

        interactor.callServices()
        wait(for: [expectation], timeout: 5.0)

        interactor.filterExchanges(with: "2")

        guard let exchangesShown = mockPresenter.exchangesShown else {
            XCTFail("exchangesShown is nil")
            return
        }

        XCTAssertEqual(exchangesShown, [exchange2])
    }
    
    func testFilterExchanges_WhenNoMatches_EmptyListIsReturned() {
        let exchange1 = ExchangeModel(name: "Test1", exchangeId: "1", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let exchange2 = ExchangeModel(name: "Test2", exchangeId: "2", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let allExchanges = [exchange1, exchange2]

        mockService.getExchangeListResult = .success(allExchanges)

        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")

        mockPresenter.showListCompletion = {
            expectation.fulfill()
        }

        interactor.callServices()
        wait(for: [expectation], timeout: 5.0)

        interactor.filterExchanges(with: "NoMatch")

        XCTAssertTrue(mockPresenter.exchangesShown?.isEmpty ?? false)
    }

    func testShowDetails_WhenCalled_PresenterShowDetailsIsCalled() {
        let exchange1 = ExchangeModel(name: "Test1", exchangeId: "1", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let exchange2 = ExchangeModel(name: "Test2", exchangeId: "2", hourVolumeUsd: 24.0, dailyVolumeUsd: 48.0, monthVolumeUsd: 96.0)
        let allExchanges = [exchange1, exchange2]
        mockService.getExchangeListResult = .success(allExchanges)

        let logo1 = ExchangeLogoModel(exchangeId: "1", url: nil)
        let logo2 = ExchangeLogoModel(exchangeId: "2", url: nil)
        let allLogos = [logo1, logo2]
        mockService.getExchangeLogosResult = .success(allLogos)

        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")
        
        mockPresenter.showListCompletion = {
            expectation.fulfill()
        }
        
        interactor.callServices()
        wait(for: [expectation], timeout: 5.0)

        interactor.showDetails(indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockPresenter.showDetailsCalled)
        XCTAssertEqual(mockPresenter.exchangesShown, allExchanges)
        XCTAssertEqual(mockPresenter.exchangesLogoShown, allLogos)
        XCTAssertEqual(mockPresenter.exchangesShown?[0], exchange1)
        XCTAssertEqual(mockPresenter.exchangesLogoShown?[0], logo1)
    }
    
    func testCallServices() {
        let exchangeListExpectation = self.expectation(description: "getExchangeList chamado")
        let exchangeLogosExpectation = self.expectation(description: "getExchangeLogos chamado")
        
        mockService.getExchangeListCompletion = {
            exchangeListExpectation.fulfill()
        }
        
        mockService.getExchangeLogosCompletion = {
            exchangeLogosExpectation.fulfill()
        }
        
        interactor.callServices()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Esperando pelos serviços, mas ocorreu um erro: \(error)")
            }
            
            XCTAssertTrue(self.mockService.getExchangeListCalled)
            XCTAssertTrue(self.mockService.getExchangeLogosCalled)
        }
    }
    
    func testFilterExchanges() {
        interactor.filterExchanges(with: "Test")
        XCTAssertTrue(mockPresenter.showListCalled)
    }
}
