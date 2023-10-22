//
//  ExchangeList.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

class ExchangesTableViewController: UITableViewController {
    var exchangeList: [ExchangeCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ExchangeListCell.self, forCellReuseIdentifier: "ExchangeListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = Colors.offBlack.color
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.layoutIfNeeded()

            if let visibleRows = self.tableView.indexPathsForVisibleRows, !visibleRows.isEmpty {
                for indexPath in visibleRows {
                    let viewModel = self.exchangeList[indexPath.section]
                    print(viewModel.exchangeIconURL)
                    viewModel.fetchImage(from: viewModel.exchangeIconURL)
                }
            } else {
                print("Nenhuma célula visível no momento!")
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return exchangeList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeListCell", for: indexPath) as! ExchangeListCell
        let viewModel = exchangeList[indexPath.section]
        cell.configure(with: viewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : Spacing.space0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModel = exchangeList[indexPath.section]
        viewModel.fetchImage(from:viewModel.exchangeIconURL)
    }
}
