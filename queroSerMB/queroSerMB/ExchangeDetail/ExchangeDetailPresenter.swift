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
    func updateChartData(ethData: [BarChartDataEntry], btcData: [BarChartDataEntry])
}

final class ExchangeDetailPresenter {
    weak var viewController: ExchangeDetailViewControllerProtocol?
    
    init() {}
}

extension ExchangeDetailPresenter: ExchangeDetailPresenterProtocol {
    func updateChartData(ethData: [BarChartDataEntry], btcData: [BarChartDataEntry]) {
        let ethEntries = ethData.map { ChartDataEntry(x: $0.x, y: $0.y) }
        let btcEntries = btcData.map { ChartDataEntry(x: $0.x, y: $0.y) }
        
        // Criar conjuntos de dados para ETH e BTC
        let ethSet = LineChartDataSet(entries: ethEntries, label: "ETH")
        ethSet.colors = [UIColor.blue]
        ethSet.drawCirclesEnabled = false
        
        let btcSet = LineChartDataSet(entries: btcEntries, label: "BTC")
        btcSet.colors = [UIColor.yellow]
        btcSet.drawCirclesEnabled = false
        btcSet.drawValuesEnabled = false
        
        let combinedData = LineChartData(dataSets: [btcSet])
        
        viewController?.updateChartData(with: combinedData)
    }
}
