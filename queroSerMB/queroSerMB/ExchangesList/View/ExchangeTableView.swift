//
//  ExchangeList.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

// MARK: - Protocol
protocol ExchangesTableViewDelegate: AnyObject {
    func didTapExchange(at indexPath: IndexPath)
}

// MARK: - Main Class
class ExchangesTableView: UITableView {
    
    // MARK: - Properties
    weak var exchangesDelegate: ExchangesTableViewDelegate?
    var exchangeList: [ExchangeCellViewModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupTableView() {
        dataSource = self
        delegate = self
        register(ExchangeListCell.self, forCellReuseIdentifier: ExchangeListCell.identifier)
        configureTableViewAppearance()
    }
    
    private func configureTableViewAppearance() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        backgroundColor = Colors.offBlack.color
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UITableViewDataSource
extension ExchangesTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exchangeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: ExchangeListCell.identifier, for: indexPath) as? ExchangeListCell else {
            return UITableViewCell()
        }
        let viewModel = exchangeList[indexPath.section]
        cell.viewModel = viewModel
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExchangesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : Spacing.space0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModel = exchangeList[indexPath.section]
        viewModel.fetchImage(from:viewModel.exchangeIconURL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exchangesDelegate?.didTapExchange(at: indexPath)
    }
}

// MARK: - ExchangeListCell
extension ExchangeListCell {
    static let identifier = "ExchangeListCell"
}
