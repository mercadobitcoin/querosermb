//
//  ExchangeDetailsProtocolsMock.swift
//  queroSerMBTests
//
//  Created by Matheus Perez on 25/10/23.
//

import Foundation
import DGCharts
import UIKit
@testable import queroSerMB

class MockExchangesDetailsViewController: ExchangeDetailViewControllerProtocol {
    var updateChartDataCalled = false
    var updatePriceValueCalled = false
    var setupContentLabelsCalled = false
    var showErrorCalled = false
    
    var chartData: LineChartData?
    var cryptoPassed: CryptoName?
    var priceValue: String?
    var intervalValue: String?
    var logo: UIImage?
    var name: String?
    var id: String?
    var volumeHour: String?
    var volumeDay: String?
    var volumeMonth: String?
    
    var setupContentLabelsCompletion: (() -> Void)?

    func updateChartData(with data: LineChartData, price: String, crypto: CryptoName, interval: String) {
        updateChartDataCalled = true
        chartData = data
        priceValue = price
        intervalValue = interval
        cryptoPassed = crypto
    }
    
    func updatePriceValue(text: String, interval: String) {
        updatePriceValueCalled = true
        priceValue = text
        intervalValue = interval
    }
    
    func setupContentLabels(logo: UIImage, name: String, id: String, volumeHour: String, volumeDay: String, volumeMonth: String) {
        setupContentLabelsCalled = true
        self.logo = logo
        self.name = name
        self.id = id
        self.volumeHour = volumeHour
        self.volumeDay = volumeDay
        self.volumeMonth = volumeMonth
        setupContentLabelsCompletion?()
    }
    
    func showError() {
        showErrorCalled = true
    }
}


class MockExchangesDetailsInteractor: ExchangeDetailInteractorProtocol {
    var updatePriceValueCalled = false
    var ohlcvEthDataMock = OHLCVData(timePeriodStart: Date(timeIntervalSince1970: 719888400.0),
                                 timePeriodEnd: Date(timeIntervalSince1970: 719892000.0),
                                 timeOpen: Date(timeIntervalSince1970: 719888404.477),
                                 timeClose: Date(timeIntervalSince1970: 719891997.6370001),
                                 priceOpen: 34012.06,
                                 priceHigh: 34367.74,
                                 priceLow: 34006.3,
                                 priceClose: 34195.79,
                                 volumeTraded: 59.23555,
                                 tradesCount: 1030)
    func setup() {}
    
    func ethGraph() {}
    
    func btcGraph() {}
    
    func updatePriceValue(data: queroSerMB.OHLCVData) {
        updatePriceValueCalled = true
    }
    
}

class MockExchangesDetailsPresenter: ExchangeDetailPresenterProtocol {
    var setupLabelsCalled = false
    var updateChartDataCalled = false
    var updateValueCalled = false
    var showErrorCalled = false
    var ohlcvDataPassed: OHLCVData?
    var exchangeReceived: ExchangeModel?
    var exchangeLogoReceived: ExchangeLogoModel?
    var updateChartDataCompletion: (() -> Void)?
    var cryptoPassed: CryptoName?

    func updateChartData(data: [DGCharts.BarChartDataEntry], priceData: OHLCVData, crypto: CryptoName) {
        updateChartDataCalled = true
        ohlcvDataPassed = priceData
        cryptoPassed = crypto
        updateChartDataCompletion?()
    }
    
    func updateValue(data: OHLCVData) {
        updateValueCalled = true
        ohlcvDataPassed = data
    }
    
    func setupLabels(data: ExchangeModel, imageData: ExchangeLogoModel) {
        setupLabelsCalled = true
        exchangeReceived = data
        exchangeLogoReceived = imageData
    }
    
    func showError() {
        showErrorCalled = true
    }
}
