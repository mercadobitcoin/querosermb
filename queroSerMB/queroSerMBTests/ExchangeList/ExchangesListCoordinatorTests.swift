//
//  ExchangesListCoordinatorTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
@testable import queroSerMB

class ExchangesListCoordinatorTests: XCTestCase {
    
    var coordinator: ExchangesListCoordinator!
    
    override func setUp() {
        super.setUp()
        coordinator = ExchangesListCoordinator(navigationController: UINavigationController())
    }
    
    func testNavigateToDetailsScene() {
        let mockExchange = ExchangeModel(name: "Test", exchangeId: "TestID", hourVolumeUsd: nil, dailyVolumeUsd: nil, monthVolumeUsd: nil)
        let mockExchangeLogo = ExchangeLogoModel(exchangeId: "TestID", url: nil)
        coordinator.navigateToDetailsScene(exchanges: mockExchange, exchangesLogo: mockExchangeLogo)
        XCTAssertTrue(coordinator.navigationController.viewControllers.contains { $0 is ExchangeDetailViewController })
    }
}
