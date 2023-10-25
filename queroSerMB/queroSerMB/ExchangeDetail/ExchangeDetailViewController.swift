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
}

// MARK: - Main Class
class ExchangeDetailViewController: UIViewController {
    // MARK: - Properties
    private let interactor: ExchangeDetailInteractorProtocol
    
    private lazy var legendPriceLabel: UILabel = {
        let label = makeLabel(text: "Valor transacionado:")
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 16))
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = makeStackView()
        return stackView
    }()
    
    private lazy var legendIntervalLabel: UILabel = {
        let label = makeLabel(text: "Intervalo:")
        return label
    }()
    
    private lazy var intervalLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 16))
        return label
    }()
    
    private lazy var intervalStackView: UIStackView = {
        let stackView = makeStackView(distribution: .fillProportionally)
        return stackView
    }()
    
    private lazy var groupPriceAndIntervalStackView: UIStackView = {
        let stackView = makeStackView(axis: .horizontal)
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var btcButton: UIButton = {
        let button = makeButton(title: "BTC", action: #selector(didTapBTC))
        return button
    }()
    
    private lazy var ethButton: UIButton = {
        let button = makeButton(title: "ETH", action: #selector(didTapETH))
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = makeStackView(axis: .horizontal, distribution: .fillEqually)
        return stackView
    }()
    
    private lazy var chartView = LineChartView()
    
    private lazy var legendLabel: UILabel = {
        let label = makeLabel(font: .systemFont(ofSize: 12), text: "* Volume transacionado pela exchange nas últimas 24 horas.")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var exchangeiconImageView: UIImageView = {
        let imageView = makeImageView(contentMode: .scaleAspectFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var exchangeNameLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 32))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeStackView: UIStackView = {
        let stackView = makeStackView(axis: .horizontal, distribution: .fill, spacing: Spacing.space1)
        return stackView
    }()
    
    private lazy var exchangeIdLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionHourLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionDayLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeVolumeTransactionMonthLabel: UILabel = {
        let label = makeLabel(font: .boldSystemFont(ofSize: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = makeScrollView()
        return scrollView
    }()
    
    private lazy var exchangeVolumeStackView: UIStackView = {
        let stackView = makeStackView(axis: .vertical, distribution: .fillEqually, alignment: .leading, spacing: Spacing.space1)
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = makeView()
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Help Makers
    private func makeLabel(font: UIFont = UIFont.systemFont(ofSize: 16), text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        return label
    }
    
    private func makeStackView(axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fillEqually, alignment: UIStackView.Alignment = .center,spacing: CGFloat = 4) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
    
    private func makeButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func makeImageView(contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }
    
    private func makeView() -> UIView {
        let view = UIView()
        return view
    }
}

// MARK: - Actions
extension ExchangeDetailViewController {
    @objc func didTapBTC() {
        interactor.btcGraph()
    }

    @objc func didTapETH() {
        interactor.ethGraph()
    }
}

// MARK: - ViewSetup
extension ExchangeDetailViewController: ViewSetup {
    func setupHierarchy() {
        view.addSubviews(activityIndicator, scrollView)
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
        scrollView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        scrollView.isHidden = false
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
}

// MARK: - ChartViewDelegate
extension ExchangeDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        interactor.updatePriceValue(data: entry.data as! OHLCVData)
    }
}
