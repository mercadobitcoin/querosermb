//
//  ExchangeDetailInteractorTests.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
import DGCharts
@testable import queroSerMB

class ExchangeDetailInteractorTests: XCTestCase {
    var interactor: ExchangeDetailInteractor!
    var mockService: MockNetworkService!
    var mockPresenter: MockExchangesDetailsPresenter!
    var exchange: ExchangeModel!
    var exchangeLogo: ExchangeLogoModel!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        mockPresenter = MockExchangesDetailsPresenter()
        exchange = ExchangeModel(name: "Test Exchange", exchangeId: "1", hourVolumeUsd: 1000, dailyVolumeUsd: 10000, monthVolumeUsd: 100000)
        exchangeLogo = ExchangeLogoModel(exchangeId: "1", url: nil)
        interactor = ExchangeDetailInteractor(exchanges: exchange,
                                              exchangesLogos: exchangeLogo,
                                              presenter: mockPresenter,
                                              service: mockService)
    }
    
    func testSetup_WhenCalled_InitialSetupIsCorrect() {
        let ohlcvData = OHLCVData(timePeriodStart: Date(), timePeriodEnd: Date(), timeOpen: Date(), timeClose: Date(), priceOpen: 1.0, priceHigh: 2.0, priceLow: 0.5, priceClose: 1.5, volumeTraded: 100.0, tradesCount: 10)
        
        mockService.getOHLCVForMajorPairsResult = .success([ohlcvData])
        
        interactor.setup()
        
        mockPresenter.setupLabels(data: exchange, imageData: exchangeLogo)
        
        XCTAssertTrue(mockPresenter.setupLabelsCalled)
        XCTAssertEqual(mockPresenter.exchangeReceived, exchange)
        XCTAssertEqual(mockPresenter.exchangeLogoReceived, exchangeLogo)
        XCTAssertTrue(mockService.getOHLCVForMajorPairsCalled)
    }
    
    func testEthGraph_WhenCalled_PresenterUpdateChartDataIsCalled() {
        let ohlcvData = OHLCVData(timePeriodStart: Date(), timePeriodEnd: Date(), timeOpen: Date(), timeClose: Date(), priceOpen: 1.0, priceHigh: 2.0, priceLow: 0.5, priceClose: 1.5, volumeTraded: 100.0, tradesCount: 10)
        mockService.getOHLCVForMajorPairsResult = .success([ohlcvData])
        
        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")
        mockPresenter.updateChartDataCompletion = {
            expectation.fulfill()
        }
        
        interactor.setup()
        interactor.ethGraph()
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(mockPresenter.updateChartDataCalled)
        XCTAssertEqual(mockPresenter.ohlcvDataPassed?.priceClose, 1.5)
        XCTAssertEqual(mockPresenter.cryptoPassed, .eth)
    }


    func testBtcGraph_WhenCalled_PresenterUpdateChartDataIsCalled() {
        let ohlcvData = OHLCVData(timePeriodStart: Date(), timePeriodEnd: Date(), timeOpen: Date(), timeClose: Date(), priceOpen: 2.0, priceHigh: 3.0, priceLow: 1.5, priceClose: 2.5, volumeTraded: 200.0, tradesCount: 20)
        mockService.getOHLCVForMajorPairsResult = .success([ohlcvData])
        
        let expectation = XCTestExpectation(description: "Aguardando chamadas assíncronas serem concluídas")
        mockPresenter.updateChartDataCompletion = {
            expectation.fulfill()
        }
        
        interactor.setup()
        interactor.btcGraph()
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(mockPresenter.updateChartDataCalled)
        XCTAssertEqual(mockPresenter.ohlcvDataPassed?.priceClose, 2.5)
        XCTAssertEqual(mockPresenter.cryptoPassed, .btc)
    }
    
    func testUpdatePriceValue_WhenCalled_PresenterUpdateValueIsCalled() {
        let ohlcvData = OHLCVData(timePeriodStart: Date(), timePeriodEnd: Date(), timeOpen: Date(), timeClose: Date(), priceOpen: 1.0, priceHigh: 2.0, priceLow: 0.5, priceClose: 1.5, volumeTraded: 100.0, tradesCount: 10)
        interactor.updatePriceValue(data: ohlcvData)
        
        XCTAssertTrue(mockPresenter.updateValueCalled)
        XCTAssertEqual(mockPresenter.ohlcvDataPassed?.priceClose, 1.5)
    }
}
