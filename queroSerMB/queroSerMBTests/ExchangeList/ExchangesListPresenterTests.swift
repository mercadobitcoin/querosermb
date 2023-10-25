//
//  ExchangesListPresenterTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
@testable import queroSerMB

class ExchangesListPresenterTests: XCTestCase {
    
    var presenter: ExchangesListPresenter!
    var mockViewController: MockExchangesListViewController!
    
    override func setUp() {
        super.setUp()
        mockViewController = MockExchangesListViewController()
        presenter = ExchangesListPresenter(coordinator: MockExchangesListCoordinator())
        presenter.viewController = mockViewController
    }
    
    func testShowList() {
        let mockExchange = ExchangeModel(name: "Test", exchangeId: "TestID", hourVolumeUsd: nil, dailyVolumeUsd: nil, monthVolumeUsd: nil)
        presenter.showList(exchanges: [mockExchange], exchangesLogo: [])
        XCTAssertTrue(mockViewController.displayListCalled)
    }
}
