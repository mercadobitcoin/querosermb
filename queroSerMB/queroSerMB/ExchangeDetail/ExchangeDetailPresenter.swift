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
        
        let price = getPriceFormatted(value: priceData.priceClose, volumeTraded: priceData.volumeTraded)
        let interval = getIntervalFormatted(start: priceData.timePeriodStart, end: priceData.timePeriodEnd)
        viewController?.updateChartData(with: LineChartData(dataSet: dataSet), price: price, crypto: crypto, interval: interval)
    }
    
    func updateValue(data: OHLCVData) {
        let price = getPriceFormatted(value: data.priceClose, volumeTraded: data.volumeTraded)
        let interval = getIntervalFormatted(start: data.timePeriodStart, end: data.timePeriodEnd)
        viewController?.updatePriceValue(text: price, interval: interval)
    }
    
    func setupLabels(data: ExchangeModel, imageData: ExchangeLogoModel) {
        let defaultLogoImage = UIImage(named: "dollarLogo")?.withTintColor(.blue)

        if let urlImage = imageData.url {
            URLSession.shared.fetchImage(from: urlImage) { [weak self] image in
                let finalLogoImage = image ?? defaultLogoImage ?? UIImage()
                self?.viewController?.setupContentLabels(logo: finalLogoImage,
                                                         name: data.name ?? "",
                                                         id: "Exchange ID:\n\(data.exchangeId ?? "")",
                                                         volumeHour: "Volume última hora:\n\(data.hourVolumeUsd?.currencyFormatter() ?? "")",
                                                         volumeDay: "Volume último dia:\n\(data.dailyVolumeUsd?.currencyFormatter() ?? "")",
                                                         volumeMonth: "Volume última mês:\n\(data.monthVolumeUsd?.currencyFormatter() ?? "")")
            }
        } else {
            viewController?.setupContentLabels(logo: defaultLogoImage ?? UIImage(),
                                               name: data.name ?? "",
                                               id: "Exchange ID:\n\(data.exchangeId ?? "")",
                                               volumeHour: "Volume última hora:\n\(data.hourVolumeUsd?.currencyFormatter() ?? "")",
                                               volumeDay: "Volume último dia:\n\(data.dailyVolumeUsd?.currencyFormatter() ?? "")",
                                               volumeMonth: "Volume última mês:\n\(data.monthVolumeUsd?.currencyFormatter() ?? "")")
        }
    }

}

private extension ExchangeDetailPresenter {
    func getPriceFormatted(value: Double?, volumeTraded: Double?) -> String {
        var price = ""
        if let priceClose = value, let volumeTraded = volumeTraded {
            let convertPrice = priceClose * volumeTraded
            price = price.currencyFormatter(value: convertPrice)
        } else {
            price = "Valor indisponível"
        }
        return price
    }
    
    func getIntervalFormatted(start: Date, end: Date) -> String {
        let timePeriodStart = Date(timeIntervalSinceReferenceDate: start.timeIntervalSinceReferenceDate)
        let timePeriodEnd = Date(timeIntervalSinceReferenceDate: end.timeIntervalSinceReferenceDate)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        let startTimeString = dateFormatter.string(from: timePeriodStart)
        let endTimeString = dateFormatter.string(from: timePeriodEnd)
        
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateString = dateFormatter.string(from: timePeriodStart)
        
        return "\(startTimeString) as \(endTimeString)\ndo dia \(dateString)"
    }
}

