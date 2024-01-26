//
//  ExchangeDetailViewController.swift
//  queroSerMB
//
//  Created by Matheus Perez on 22/10/23.
//
import Charts
import UIKit
import DGCharts

// MARK: - Protocols
protocol ExchangeDetailViewControllerProtocol: AnyObject {
    func updateChartData(with data: LineChartData, price: String, crypto: CryptoName, interval: String)
    func updatePriceValue(text: String, interval: String)
    func setupContentLabels(logo: UIImage, name: String, id: String, volumeHour: String, volumeDay: String, volumeMonth: String)
    func showError()
}

// MARK: - Main Class
class ExchangeDetailViewController: UIViewController {
    // MARK: - Properties
    private let interactor: ExchangeDetailInteractorProtocol
    
    private lazy var legendPriceLabel: UILabel = UILabel.make(text: "Valor transacionado:")
    
    private(set) lazy var priceLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 16))
    
    private lazy var priceStackView: UIStackView = UIStackView.make()
    
    private lazy var legendIntervalLabel: UILabel = UILabel.make(text: "Intervalo:")
    
    private(set) lazy var intervalLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 16))
    
    private lazy var intervalStackView: UIStackView = UIStackView.make(distribution: .fillProportionally)
    
    private lazy var groupPriceAndIntervalStackView: UIStackView = UIStackView.make(axis: .horizontal,
                                                                                    spacing: Spacing.space1)
    
    private(set) lazy var btcButton: UIButton = UIButton.make(title: "BTC",
                                                              target: self,
                                                              action: #selector(didTapBTC))
    
    private(set) lazy var ethButton: UIButton =  UIButton.make(title: "ETH",
                                                               target: self,
                                                               action: #selector(didTapETH))
    
    private lazy var buttonStackView: UIStackView = UIStackView.make(axis: .horizontal,
                                                                     distribution: .fillEqually)
    
    private(set) lazy var chartView = LineChartView()
    
    private lazy var legendLabel: UILabel = UILabel.make(font: .systemFont(ofSize: 12),
                                                         text: "* Volume transacionado pela exchange nas últimas 24 horas.")
    
    private(set) lazy var exchangeiconImageView: UIImageView = UIImageView.make(contentMode: .scaleAspectFill)
    
    private(set) lazy var exchangeNameLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 32))
    
    private lazy var exchangeStackView: UIStackView = UIStackView.make(axis: .horizontal,
                                                                       distribution: .fill, spacing: Spacing.space1)
    
    private(set) lazy var exchangeIdLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 16))
    
    private(set) lazy var exchangeVolumeTransactionHourLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 16))
    
    private(set) lazy var exchangeVolumeTransactionDayLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 16))
    
    private(set) lazy var exchangeVolumeTransactionMonthLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 16))
    
    private lazy var scrollView: UIScrollView = UIScrollView.make()
    
    private lazy var exchangeVolumeStackView: UIStackView = UIStackView.make(axis: .vertical,
                                                                             distribution: .fillEqually,
                                                                             alignment: .leading,
                                                                             spacing: Spacing.space1)
    
    private lazy var contentView: UIView = UIView()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private lazy var exchangeErrorFetchListLabel: UILabel = UILabel.make(font: UIFont.boldSystemFont(ofSize: 32),
                                                                         text: "Não foi possível carregar as informações",
                                                                         textAlignment: .center)
    
    private lazy var retryFetchListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tentar novamente", for: .normal)
        button.setTitleColor(Colors.offGray.color, for: .normal)
        button.backgroundColor = Colors.white.color
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(retryFetchList), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var errorStackView: UIStackView = UIStackView.make(distribution: .fillProportionally,
                                                                         spacing: Spacing.space2)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        interactor.setup()
    }
    
    // MARK: - Initializers
    init(interactor: ExchangeDetailInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
}

// MARK: - Actions
extension ExchangeDetailViewController {
    @objc func didTapBTC() {
        interactor.btcGraph()
    }
    
    @objc func didTapETH() {
        interactor.ethGraph()
    }
    
    @objc func retryFetchList() {
        interactor.setup()
    }
}

// MARK: - ViewSetup
extension ExchangeDetailViewController: ViewSetup {
    func setupHierarchy() {
        errorStackView.addArrangedSubviews(exchangeErrorFetchListLabel,
                                           retryFetchListButton)
        view.addSubviews(activityIndicator, errorStackView, scrollView)
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
        exchangeiconImageView.translatesAutoresizingMaskIntoConstraints = false
        errorStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            groupPriceAndIntervalStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: Spacing.space0),
            groupPriceAndIntervalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.space5),
            intervalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.space5),
            intervalLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: groupPriceAndIntervalStackView.bottomAnchor, constant: Spacing.space2),
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
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space3),
            errorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space3)
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
        errorStackView.isHidden = true
        scrollView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        scrollView.isHidden = false
        errorStackView.isHidden = true
        activityIndicator.stopAnimating()
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

// MARK: - ExchangeDetailViewControllerProtocol
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
        
        stopLoading()
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
    
    func showError() {
        activityIndicator.stopAnimating()
        errorStackView.isHidden = false
    }
}

// MARK: - ChartViewDelegate
extension ExchangeDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        interactor.updatePriceValue(data: entry.data as! OHLCVData)
    }
}
