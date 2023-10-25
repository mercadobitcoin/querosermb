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
    
    func testInitialUIConfigurations() {
        XCTAssertTrue(viewController.exchangeTable.isHidden)
        XCTAssertTrue(viewController.activityIndicator.isAnimating)
        XCTAssertTrue(viewController.errorStackView.isHidden)
    }

    func testUIUpdatesOnDisplayList() {
        let mockList = [ExchangeCellViewModel(from: ExchangeModel(name: "Test", exchangeId: "TestID", hourVolumeUsd: nil, dailyVolumeUsd: nil, monthVolumeUsd: nil), logoUrl: nil)]
        viewController.displayList(exchangeList: mockList)
        XCTAssertEqual(viewController.exchangeTable.exchangeList.count, 1)
        XCTAssertFalse(viewController.activityIndicator.isAnimating)
        XCTAssertFalse(viewController.exchangeTable.isHidden)
        XCTAssertTrue(viewController.errorStackView.isHidden)
    }
    
    func testUIUpdatesOnDisplayError() {
        viewController.displayError()
        XCTAssertFalse(viewController.activityIndicator.isAnimating)
        XCTAssertFalse(viewController.errorStackView.isHidden)
    }
    
    func testFilteringWhenTypingInSearchBar() {
        viewController.searchBar.text = "Test"
        let _ = viewController.textField(viewController.searchBar, shouldChangeCharactersIn: NSRange(location: 0, length: 4), replacementString: "Test")
        XCTAssertTrue(mockInteractor.exchangesFiltered)
    }

    func testFilteringWhenClearingSearchBar() {
        viewController.textFieldShouldClear(viewController.searchBar)
        XCTAssertTrue(mockInteractor.exchangesFiltered)
    }

    func testDidTapExchange() {
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.didTapExchange(at: indexPath)
        XCTAssertTrue(mockInteractor.detailsRequested)
    }

    func testViewDidLoadCallsServices() {
        viewController.viewDidLoad()
        XCTAssertTrue(mockInteractor.servicesCalled)
    }

    func testRetryFetchListCallsServices() {
        viewController.retryFetchList()
        XCTAssertTrue(mockInteractor.servicesCalled)
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
