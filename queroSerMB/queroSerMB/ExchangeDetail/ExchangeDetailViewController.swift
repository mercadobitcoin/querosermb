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
    func updateChartData(with data: LineChartData, price: String, crypto: CryptoName, interval: String)
    func updatePriceValue(text: String, interval: String)
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
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var legendIntervalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Intervalo:"
        return label
    }()
    
    private lazy var intervalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var intervalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var groupPriceAndIntervalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var exchangeVolumeTransactionHourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionMonthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var exchangeVolumeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = Spacing.space1
        return stackView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
    //    view.isUserInteractionEnabled = true
        return view
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        buttonStackView.addArrangedSubviews(btcButton,
                                            ethButton)
        exchangeStackView.addArrangedSubviews(exchangeiconImageView,
                                              exchangeNameLabel)
        priceStackView.addArrangedSubviews(legendPriceLabel,
                                           priceLabel)
        intervalStackView.addArrangedSubviews(legendIntervalLabel,
                                              intervalLabel)
        groupPriceAndIntervalStackView.addArrangedSubviews(priceStackView,
                                                           intervalStackView)
        
        exchangeVolumeStackView.addArrangedSubviews(exchangeIdLabel,
                                                    exchangeVolumeTransactionHourLabel,
                                                    exchangeVolumeTransactionDayLabel,
                                                    exchangeVolumeTransactionMonthLabel)
        contentView.addSubviews(buttonStackView,
                                groupPriceAndIntervalStackView,
                                chartView,
                                legendLabel,
                                exchangeStackView,
                                exchangeVolumeStackView)
    }
    
    func setupConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        groupPriceAndIntervalStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        legendLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeStackView.translatesAutoresizingMaskIntoConstraints = false
        exchangeVolumeStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exchangeStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            exchangeStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            exchangeStackView.heightAnchor.constraint(equalToConstant: 48),
            exchangeiconImageView.heightAnchor.constraint(equalToConstant: 48),
            exchangeiconImageView.widthAnchor.constraint(equalToConstant: 48),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: exchangeStackView.bottomAnchor, constant: Spacing.space4),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space5),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space5),
            buttonStackView.heightAnchor.constraint(equalToConstant: 34),
        ])
        
        NSLayoutConstraint.activate([
            groupPriceAndIntervalStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: Spacing.space4),
            groupPriceAndIntervalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space5),
            intervalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space5),
            intervalLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: intervalStackView.bottomAnchor, constant: Spacing.space2),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space5),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space5),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            legendLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: Spacing.space2),
            legendLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space5),
            legendLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space5),
        ])
        
        NSLayoutConstraint.activate([
            exchangeVolumeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space5),
            exchangeVolumeStackView.topAnchor.constraint(equalTo: legendLabel.bottomAnchor, constant: Spacing.space2),
            exchangeVolumeTransactionMonthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.space5)
        ])
    }
    
    func setupStyles() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = Colors.white.color
        
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

extension ExchangeDetailViewController: ExchangeDetailViewControllerProtocol {
    func updateChartData(with data: LineChartData, price: String, crypto: CryptoName, interval: String) {
        chartView.data = data
        
        chartView.animate(xAxisDuration: 1.5, yAxisDuration: 0.0, easingOption: .easeInOutQuart)
        chartView.notifyDataSetChanged()
        priceLabel.text = price
        intervalLabel.text = interval
        
        UIView.animate(withDuration: 0.5) {
            switch crypto {
            case .btc:
                self.btcButton.backgroundColor = Colors.offGray.color
                self.ethButton.backgroundColor = .clear
            case .eth:
                self.ethButton.backgroundColor = Colors.offGray.color
                self.btcButton.backgroundColor = .clear
            }
        }
    }
    
    func updatePriceValue(text: String, interval: String) {
        priceLabel.text = text
        intervalLabel.text = interval
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
