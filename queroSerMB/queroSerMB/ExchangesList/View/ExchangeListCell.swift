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
    private lazy var exchangeiconImageView: UIImageView = UIImageView.make(contentMode: .scaleAspectFill)

    private lazy var exchangeNameLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 14))

    private lazy var exchangeIdLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 14))

    private lazy var exchangeVolumeTransactionDayLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 20))

    private lazy var timePeriodLabel: UILabel = UILabel.make(font: .boldSystemFont(ofSize: 12), text: "Em 24 horas")
    
    private lazy var exchangeInfosStackView: UIStackView = UIStackView.make(alignment: .leading, spacing: Spacing.space2)

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) { nil }

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
        backgroundColor = Colors.offGray.color
        layer.cornerRadius = 10
        layer.masksToBounds = true
        selectionStyle = .none
    }

    func setupConstraints() {
        exchangeiconImageView.translatesAutoresizingMaskIntoConstraints = false
        exchangeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeInfosStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
}
