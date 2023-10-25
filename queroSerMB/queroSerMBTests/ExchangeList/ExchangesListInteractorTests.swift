//
//  ExchangesListInteractorTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
@testable import queroSerMB

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
