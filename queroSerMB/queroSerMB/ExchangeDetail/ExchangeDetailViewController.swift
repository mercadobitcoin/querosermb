//
//  ExchangeDetailViewController.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//

import Charts
import UIKit
import DGCharts

protocol ExchangeDetailViewControllerProtocol: AnyObject {
    func updateChartData(with data: LineChartData)
}

class ExchangeDetailViewController: UIViewController {
    
    private lazy var chartView: LineChartView = {
        let chart = LineChartView()
        // Outras configurações do gráfico, se necessário
        return chart
    }()
    
    let marker = CustomMarkerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        interactor.setup()
    }
    
    private let interactor: ExchangeDetailInteractorProtocol
    
    init(interactor: ExchangeDetailInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExchangeDetailViewController: ViewSetup {
    func setupHierarchy() {
        view.addSubview(chartView)
    }
    
    func setupConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setupStyles() {
        view.backgroundColor = Colors.offBlack.color
        setupChart()
    }
    
    private func setupChart() {
        marker.chartView = chartView
        chartView.marker = marker
        chartView.chartDescription.text = "Volume USD"
        chartView.backgroundColor = .clear
        chartView.doubleTapToZoomEnabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.drawBordersEnabled = false
        
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.legend.enabled = false
        
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
    }
}

extension ExchangeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ExchangeDetailViewController: ExchangeDetailViewControllerProtocol {
    func updateChartData(with data: LineChartData) {
        chartView.data = data
        chartView.notifyDataSetChanged()
    }
}

class CustomMarkerView: MarkerView {
    var text = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        text = "\(entry.y)"
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.black]
        let size = text.size(withAttributes: attributes)
        let rect = CGRect(origin: CGPoint(x: point.x - size.width / 2, y: point.y - size.height), size: size)
        
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        text.draw(in: rect, withAttributes: attributes)
    }
}


