//
//  ExchangesDetailsViewControllerTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
import DGCharts
@testable import queroSerMB

class ExchangeDetailViewControllerTests: XCTestCase {

    var viewController: ExchangeDetailViewController!
    var mockInteractor: MockExchangesDetailsInteractor!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockExchangesDetailsInteractor()
        viewController = ExchangeDetailViewController(interactor: mockInteractor)
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testUpdateChartData() {
        let data = LineChartData()
        let price = "$1234"
        let crypto = CryptoName.btc
        let interval = "1H"

        viewController.updateChartData(with: data, price: price, crypto: crypto, interval: interval)

        XCTAssertEqual(viewController.chartView.data, data)
        XCTAssertEqual(viewController.priceLabel.text, price)
        XCTAssertEqual(viewController.intervalLabel.text, interval)
        XCTAssertEqual(viewController.btcButton.backgroundColor, Colors.offGray.color)
        XCTAssertEqual(viewController.ethButton.backgroundColor, .clear)
    }

    func testUpdatePriceValue() {
        let text = "$1234"
        let interval = "1H"

        viewController.updatePriceValue(text: text, interval: interval)

        XCTAssertEqual(viewController.priceLabel.text, text)
        XCTAssertEqual(viewController.intervalLabel.text, interval)
    }

    func testSetupContentLabels() {
        let logo = UIImage()
        let name = "Exchange Name"
        let id = "12345"
        let volumeHour = "1000"
        let volumeDay = "20000"
        let volumeMonth = "300000"

        viewController.setupContentLabels(logo: logo, name: name, id: id, volumeHour: volumeHour, volumeDay: volumeDay, volumeMonth: volumeMonth)

        XCTAssertEqual(viewController.exchangeiconImageView.image, logo)
        XCTAssertEqual(viewController.exchangeNameLabel.text, name)
        XCTAssertEqual(viewController.exchangeIdLabel.text, id)
        XCTAssertEqual(viewController.exchangeVolumeTransactionHourLabel.text, volumeHour)
        XCTAssertEqual(viewController.exchangeVolumeTransactionDayLabel.text, volumeDay)
        XCTAssertEqual(viewController.exchangeVolumeTransactionMonthLabel.text, volumeMonth)
    }

    func testShowError() {
        viewController.showError()

        XCTAssertFalse(viewController.activityIndicator.isAnimating)
        XCTAssertFalse(viewController.errorStackView.isHidden)
    }

    func testChartValueSelected() {
        
        let entry = ChartDataEntry(x: 7.0, y: 59.23555, data: self.mockInteractor.ohlcvEthDataMock)
        let highlight = Highlight(x: 7.0, y: 59.23555, dataSetIndex: 0)
        
        viewController.chartValueSelected(viewController.chartView, entry: entry, highlight: highlight)
        
        XCTAssertTrue(mockInteractor.updatePriceValueCalled)
    }
}

