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
    func updateChartData(with data: LineChartData, price: String, crypto: CryptoName)
    func updatePriceValue(text: String)
    func setupContentLabels(logo: UIImage, name: String, id: String, volumeHour: String, volumeDay: String, volumeMonth: String)
}

class ExchangeDetailViewController: UIViewController {
    
    private lazy var legendPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Valor transacionado:"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.textAlignment = .center
        return label
    }()

    private lazy var btcButton: UIButton = {
        let button = UIButton()
        button.setTitle("BTC", for: .normal)
        button.addTarget(self, action: #selector(didTapBTC), for: .touchUpInside)
        return button
    }()

    private lazy var ethButton: UIButton = {
        let button = UIButton()
        button.setTitle("ETH", for: .normal)
        button.addTarget(self, action: #selector(didTapETH), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var chartView = LineChartView()
    
    private lazy var legendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "* Volume transacionado pela exchange nas últimas 24 horas."
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var exchangeiconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var exchangeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Spacing.space1
        return stackView
    }()
    
    private lazy var exchangeIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var exchangeVolumeTransactionHourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionMonthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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

extension ExchangeDetailViewController {
    @objc func didTapBTC() {
        interactor.btcGraph()
    }

    @objc func didTapETH() {
        interactor.ethGraph()
    }
}

extension ExchangeDetailViewController: ViewSetup {
    func setupHierarchy() {
        buttonStackView.addArrangedSubview(btcButton)
        buttonStackView.addArrangedSubview(ethButton)
        exchangeStackView.addArrangedSubview(exchangeiconImageView)
        exchangeStackView.addArrangedSubview(exchangeNameLabel)
        view.addSubviews(buttonStackView,
                         legendPriceLabel,
                         priceLabel,
                         chartView,
                         legendLabel,
                         exchangeStackView,
                         exchangeIdLabel,
                         exchangeVolumeTransactionHourLabel,
                         exchangeVolumeTransactionDayLabel,
                         exchangeVolumeTransactionMonthLabel)
    }
    
    func setupConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        legendPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        legendLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeStackView.translatesAutoresizingMaskIntoConstraints = false
        exchangeIdLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeVolumeTransactionHourLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeVolumeTransactionDayLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeVolumeTransactionMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exchangeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exchangeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exchangeStackView.heightAnchor.constraint(equalToConstant: 48),
            exchangeiconImageView.heightAnchor.constraint(equalToConstant: 48),
            exchangeiconImageView.widthAnchor.constraint(equalToConstant: 48),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: exchangeStackView.bottomAnchor, constant: Spacing.space4),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            buttonStackView.heightAnchor.constraint(equalToConstant: 34),
        ])
        
        NSLayoutConstraint.activate([
            legendPriceLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: Spacing.space4),
            legendPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            legendPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            legendPriceLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: legendPriceLabel.bottomAnchor, constant: Spacing.space1),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            priceLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Spacing.space2),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            legendLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: Spacing.space2),
            legendLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            legendLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
        ])
        
        NSLayoutConstraint.activate([
            exchangeIdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            exchangeIdLabel.topAnchor.constraint(equalTo: legendLabel.bottomAnchor, constant: Spacing.space2)
        ])
        
        NSLayoutConstraint.activate([
            exchangeVolumeTransactionHourLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            exchangeVolumeTransactionHourLabel.topAnchor.constraint(equalTo: exchangeIdLabel.bottomAnchor, constant: Spacing.space2)
        ])
        
        NSLayoutConstraint.activate([
            exchangeVolumeTransactionDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            exchangeVolumeTransactionDayLabel.topAnchor.constraint(equalTo: exchangeVolumeTransactionHourLabel.bottomAnchor, constant: Spacing.space2)
        ])
        
        NSLayoutConstraint.activate([
            exchangeVolumeTransactionMonthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            exchangeVolumeTransactionMonthLabel.topAnchor.constraint(equalTo: exchangeVolumeTransactionDayLabel.bottomAnchor, constant: Spacing.space2)
        ])
    }
    
    func setupStyles() {
        view.backgroundColor = Colors.offBlack.color
        btcButton.backgroundColor = Colors.offGray.color
        setupChart()
    }
    
    private func setupChart() {
        chartView.delegate = self
        
        chartView.backgroundColor = .clear
        chartView.doubleTapToZoomEnabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.drawBordersEnabled = false
        
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.legend.enabled = false
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = 6
        chartView.xAxis.granularity = 4.0
        chartView.xAxis.labelTextColor = .white
    }
}

extension ExchangeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ExchangeDetailViewController: ExchangeDetailViewControllerProtocol {
    func updateChartData(with data: LineChartData, price: String, crypto: CryptoName) {
        chartView.data = data
        chartView.notifyDataSetChanged()
        priceLabel.text = price
        
        switch crypto {
        case .btc:
            btcButton.backgroundColor = Colors.offGray.color
            ethButton.backgroundColor = .clear
        case .eth:
            ethButton.backgroundColor = Colors.offGray.color
            btcButton.backgroundColor = .clear
        }
    }
    
    func updatePriceValue(text: String) {
        priceLabel.text = text
    }
    
    func setupContentLabels(logo: UIImage, name: String, id: String, volumeHour: String, volumeDay: String, volumeMonth: String) {
        exchangeiconImageView.image = logo
        exchangeNameLabel.text = name
        exchangeIdLabel.text = id
        exchangeVolumeTransactionHourLabel.text = volumeHour
        exchangeVolumeTransactionDayLabel.text = volumeDay
        exchangeVolumeTransactionMonthLabel.text = volumeMonth
    }
}

extension ExchangeDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        interactor.updatePriceValue(data: entry.data as! OHLCVData)
    }
}
