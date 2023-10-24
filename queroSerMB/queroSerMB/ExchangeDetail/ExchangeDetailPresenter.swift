//
//  ExchangeDetailPresenter.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import Foundation
import DGCharts
import UIKit

protocol ExchangeDetailPresenterProtocol: AnyObject {
    func updateChartData(data: [BarChartDataEntry], priceData: OHLCVData, crypto: CryptoName)
    func updateValue(data: OHLCVData)
    func setupLabels(data: ExchangeModel, imageData: ExchangeLogoModel)
}

final class ExchangeDetailPresenter {
    weak var viewController: ExchangeDetailViewControllerProtocol?
    
    init() {}
}

extension ExchangeDetailPresenter: ExchangeDetailPresenterProtocol {
    func updateChartData(data: [BarChartDataEntry], priceData: OHLCVData, crypto: CryptoName) {
        let dataEntries = data.map { ChartDataEntry(x: $0.x, y: $0.y, data: $0.data) }
        
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.colors = [UIColor.yellow]
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        
        var price = ""
        if let priceClose = priceData.priceClose, let volumeTraded = priceData.volumeTraded {
            let convertPrice = priceClose * volumeTraded
            price = price.currencyFormatter(value: convertPrice)
        } else {
            price = "Valor indisponível"
        }
        
        viewController?.updateChartData(with: LineChartData(dataSet: dataSet), price: price, crypto: crypto)
    }
    
    func updateValue(data: OHLCVData) {
        var price = ""
        if let priceClose = data.priceClose, let volumeTraded = data.volumeTraded {
            let convertPrice = priceClose * volumeTraded
            price = price.currencyFormatter(value: convertPrice)
        } else {
            price = "Valor indisponível"
        }
        viewController?.updatePriceValue(text: price)
    }
    
    func setupLabels(data: ExchangeModel, imageData: ExchangeLogoModel) {
        var logoImage = UIImage(named: "dollarLogo")?.withTintColor(.blue)
        if let urlImage = imageData.url {
            URLSession.shared.fetchImage(from: urlImage) { [weak self] image in
                logoImage = image
            }
        }

        viewController?.setupContentLabels(logo: logoImage ?? UIImage(),
                                           name: data.name ?? "",
                                           id: "Exchange ID: \(data.exchangeId ?? "")",
                                           volumeHour: "Volume última hora: \(data.hourVolumeUsd?.currencyFormatter() ?? "")",
                                           volumeDay: "Volume último dia: \(data.dailyVolumeUsd?.currencyFormatter() ?? "")",
                                           volumeMonth: "Volume última mês: \(data.monthVolumeUsd?.currencyFormatter() ?? "")")
    }
}

extension Double {
    func currencyFormatter() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString
        } else {
            return ""
        }
    }
}

