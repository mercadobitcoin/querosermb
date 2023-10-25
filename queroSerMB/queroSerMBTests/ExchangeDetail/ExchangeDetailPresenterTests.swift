//
//  ExchangeDetailPresenterTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
import DGCharts
@testable import queroSerMB

class ExchangeDetailPresenterTests: XCTestCase {
    
    var presenter: ExchangeDetailPresenter!
    var mockViewController: MockExchangesDetailsViewController!
    
    override func setUp() {
        super.setUp()
        mockViewController = MockExchangesDetailsViewController()
        presenter = ExchangeDetailPresenter()
        presenter.viewController = mockViewController
    }
    
    func testUpdateChartData_WhenCalled_ViewControllerMethodCalledWithCorrectData() {
        let data = [BarChartDataEntry(x: 1.0, y: 2.0)]
        let startDate = Date()
        let endDate = Date()
        let priceData = OHLCVData(timePeriodStart: startDate, timePeriodEnd: endDate, timeOpen: startDate, timeClose: endDate, priceOpen: 1.0, priceHigh: 2.0, priceLow: 0.5, priceClose: 1.5, volumeTraded: 100.0, tradesCount: 10)
        let crypto = CryptoName.eth
        
        let expectedPrice = (priceData.priceClose ?? 0) * (priceData.volumeTraded ?? 0)
        let formattedExpectedPrice = expectedPrice.currencyFormatter()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let startTimeString = timeFormatter.string(from: startDate)
        let endTimeString = timeFormatter.string(from: endDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateString = dateFormatter.string(from: startDate)
        
        let expectedInterval = "\(startTimeString) as \(endTimeString)\ndo dia \(dateString)"
        
        presenter.updateChartData(data: data, priceData: priceData, crypto: crypto)
        
        guard let dataSet = mockViewController.chartData?.dataSets.first as? LineChartDataSet else {
            XCTFail("LineChartDataSet não encontrado")
            return
        }
        
        guard let chartDataEntry = dataSet.entries.first else {
            XCTFail("ChartDataEntry não encontrado")
            return
        }
        XCTAssertEqual(chartDataEntry.y, 2.0)
        XCTAssertEqual(mockViewController.priceValue, formattedExpectedPrice)
        XCTAssertEqual(mockViewController.cryptoPassed, CryptoName.eth)
        XCTAssertEqual(mockViewController.intervalValue, expectedInterval)
    }
    
    
    func testUpdateValue_WhenCalled_ViewControllerMethodCalledWithCorrectData() {
        let data = OHLCVData(timePeriodStart: Date(), timePeriodEnd: Date(), timeOpen: Date(), timeClose: Date(), priceOpen: 1.0, priceHigh: 2.0, priceLow: 0.5, priceClose: 1.5, volumeTraded: 100.0, tradesCount: 10)
        let startDate = Date()
        let endDate = Date()
        let expectedPrice = (data.priceClose ?? 0) * (data.volumeTraded ?? 0)
        let formattedExpectedPrice = expectedPrice.currencyFormatter()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let startTimeString = timeFormatter.string(from: startDate)
        let endTimeString = timeFormatter.string(from: endDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateString = dateFormatter.string(from: startDate)
        
        let expectedInterval = "\(startTimeString) as \(endTimeString)\ndo dia \(dateString)"
        
        presenter.updateValue(data: data)
        
        XCTAssertEqual(mockViewController.priceValue, formattedExpectedPrice)
        XCTAssertEqual(mockViewController.intervalValue, expectedInterval)
    }
    
    func testSetupLabels_WhenCalled_ViewControllerMethodCalledWithCorrectData() {
        let data = ExchangeModel(name: "Name",
                                 exchangeId: "123",
                                 hourVolumeUsd: 1000.0,
                                 dailyVolumeUsd: 10000.0,
                                 monthVolumeUsd: 100000.0)
        let imageData = ExchangeLogoModel(exchangeId: "123",
                                          url: URL(string: "https://example.com/logo.png"))
        
        let expectation = XCTestExpectation(description: "Aguardando carregamento da imagem")
        mockViewController.setupContentLabelsCompletion = {
            expectation.fulfill()
        }
        
        presenter.setupLabels(data: data, imageData: imageData)
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(mockViewController.logo)
        XCTAssertEqual(mockViewController.name, data.name)
        XCTAssertEqual(mockViewController.id, "Exchange ID:\n\(data.exchangeId ?? "")")
        XCTAssertEqual(mockViewController.volumeHour, "Volume última hora:\n\(data.hourVolumeUsd?.currencyFormatter() ?? "")")
        XCTAssertEqual(mockViewController.volumeDay, "Volume último dia:\n\(data.dailyVolumeUsd?.currencyFormatter() ?? "")")
        XCTAssertEqual(mockViewController.volumeMonth, "Volume última mês:\n\(data.monthVolumeUsd?.currencyFormatter() ?? "")")
    }
    
    func testShowError_WhenCalled_ViewControllerMethodCalled() {
        presenter.showError()
        
        XCTAssertTrue(mockViewController.showErrorCalled)
    }
}
