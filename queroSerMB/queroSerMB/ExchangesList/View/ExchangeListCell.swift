//
//  ExchangeListCell.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

class ExchangeListCell: UITableViewCell {

    // MARK: - Properties
    var viewModel: ExchangeCellViewModel? {
        didSet {
            viewModel?.cancelImageDownload()
        }
    }

    // MARK: - UI Components
    private lazy var exchangeiconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var exchangeNameLabel: UILabel = {
        let label = makeLabel(fontSize: 14)
        return label
    }()

    private lazy var exchangeIdLabel: UILabel = {
        let label = makeLabel(fontSize: 14)
        return label
    }()

    private lazy var exchangeVolumeTransactionDayLabel: UILabel = {
        let label = makeLabel(fontSize: 20)
        return label
    }()

    private lazy var timePeriodLabel: UILabel = {
        let label = makeLabel(fontSize: 12)
        label.text = "Em 24 horas"
        return label
    }()
    
    private lazy var exchangeInfosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = Spacing.space2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelImageDownload()
    }

    // MARK: - Setup Methods
    private func setupViews() {
        setupVisualAppearance()
        exchangeInfosStackView.addArrangedSubviews(exchangeIdLabel, exchangeVolumeTransactionDayLabel, timePeriodLabel)
        addSubviews(exchangeiconImageView, exchangeNameLabel, exchangeInfosStackView)
        setupConstraints()
    }

    private func setupVisualAppearance() {
        self.backgroundColor = Colors.offGray.color
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.selectionStyle = .none
    }

    func setupConstraints() {
        addSubviews(exchangeiconImageView, 
                    exchangeNameLabel,
                    exchangeInfosStackView)
        
        NSLayoutConstraint.activate([
            exchangeiconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space5),
            exchangeiconImageView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space5),
            exchangeiconImageView.widthAnchor.constraint(equalToConstant: 32),
            exchangeiconImageView.heightAnchor.constraint(equalToConstant: 32)
        ])

        NSLayoutConstraint.activate([
            exchangeNameLabel.leadingAnchor.constraint(equalTo: exchangeiconImageView.trailingAnchor, constant: Spacing.space1),
            exchangeNameLabel.centerYAnchor.constraint(equalTo: exchangeiconImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exchangeInfosStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space5),
            exchangeInfosStackView.topAnchor.constraint(equalTo: exchangeiconImageView.bottomAnchor, constant: Spacing.space2),
            exchangeInfosStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space5)
        ])
    }

    // MARK: - Configure Method
    func configure(with viewModel: ExchangeCellViewModel) {
        exchangeNameLabel.text = viewModel.name
        exchangeVolumeTransactionDayLabel.text = viewModel.dailyVolumeUsdText
        exchangeiconImageView.image = viewModel.exchangeIconImage
        exchangeIdLabel.text = viewModel.id
        
        viewModel.onLogoImageUpdated = { [weak self] image in
            DispatchQueue.main.async {
                self?.exchangeiconImageView.image = image
            }
        }
    }

    // MARK: - Utility Methods
    private func makeLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
