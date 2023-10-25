//
//  ExchangeListViewControllerTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
@testable import queroSerMB

class ExchangesListViewControllerTests: XCTestCase {
    
    var viewController: ExchangesListViewController!
    var mockInteractor: MockExchangesListInteractor!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockExchangesListInteractor()
        viewController = ExchangesListViewController(interactor: mockInteractor)
        _ = viewController.view
    }
    
    func testCallServicesOnLoad() {
        viewController.viewDidLoad()
        XCTAssertTrue(mockInteractor.servicesCalled, "Services should be called on viewDidLoad")
    }
    
    func testDisplayList() {
        let mockList = [ExchangeCellViewModel(from: ExchangeModel(name: "Test", exchangeId: "TestID", hourVolumeUsd: nil, dailyVolumeUsd: nil, monthVolumeUsd: nil), logoUrl: nil)]
        viewController.displayList(exchangeList: mockList)
        XCTAssertEqual(viewController.exchangeTable.exchangeList.count, 1)
    }
    
    func testSearchBarFilter() {
        viewController.textFieldShouldClear(viewController.searchBar)
        XCTAssertTrue(mockInteractor.exchangesFiltered, "Filter should be called when search bar is cleared")
    }
}
