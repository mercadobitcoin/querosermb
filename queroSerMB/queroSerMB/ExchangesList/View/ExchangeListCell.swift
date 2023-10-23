//
//  ExchangeListCell.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

class ExchangeListCell: UITableViewCell {

    private lazy var exchangeiconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var exchangeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exchangeIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var exchangeVolumeTransactionDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Colors.white.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timePeriodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.white.color
        label.text = "Em 24 horas"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.backgroundColor = Colors.offGray.color
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.selectionStyle = .none
        
        addSubviews(exchangeiconImageView, exchangeNameLabel, exchangeIdLabel, exchangeVolumeTransactionDayLabel, timePeriodLabel)
        
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
            exchangeIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space5),
            exchangeIdLabel.topAnchor.constraint(equalTo: exchangeiconImageView.bottomAnchor, constant: Spacing.space2)
        ])

        NSLayoutConstraint.activate([
            exchangeVolumeTransactionDayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space5),
            exchangeVolumeTransactionDayLabel.topAnchor.constraint(equalTo: exchangeIdLabel.bottomAnchor, constant: Spacing.space2)
        ])

        NSLayoutConstraint.activate([
            timePeriodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space5),
            timePeriodLabel.topAnchor.constraint(equalTo: exchangeVolumeTransactionDayLabel.bottomAnchor, constant: Spacing.space1),
            timePeriodLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Spacing.space5)
        ])
    }

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
