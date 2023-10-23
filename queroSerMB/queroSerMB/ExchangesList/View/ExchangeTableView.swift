//
//  ExchangeList.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

protocol ExchangesTableViewDelegate: AnyObject {
    func didTapExchange(at indexPath: IndexPath)
}

class ExchangesTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var exchangesDelegate: ExchangesTableViewDelegate?
    var exchangeList: [ExchangeCellViewModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        dataSource = self
        delegate = self
        register(ExchangeListCell.self, forCellReuseIdentifier: "ExchangeListCell")
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        backgroundColor = Colors.offBlack.color
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exchangeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "ExchangeListCell", for: indexPath) as! ExchangeListCell
        let viewModel = exchangeList[indexPath.section]
        cell.configure(with: viewModel)
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
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
