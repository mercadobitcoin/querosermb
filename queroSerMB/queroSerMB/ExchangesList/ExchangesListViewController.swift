//
//  ExchangesListViewController.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

protocol ExchangesListViewControllerProtocol: AnyObject {
    func displayList(exchangeList: [ExchangeCellViewModel])
}

class ExchangesListViewController: UIViewController {
    private lazy var searchBar = ExchangeSearchBar()
    private lazy var exchangeTable = ExchangesTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        interactor.callServices()
    }
    
    private let interactor: ExchangesListInteractorProtocol
    
    init(interactor: ExchangesListInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExchangesListViewController: ViewSetup {
    func setupHierarchy() {
        view.addSubview(searchBar)
        
        addChild(exchangeTable)
        view.addSubview(exchangeTable.tableView)
        exchangeTable.didMove(toParent: self)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space2),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space3),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space3)
        ])
        
        exchangeTable.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exchangeTable.tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Spacing.space3),
            exchangeTable.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            exchangeTable.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space3),
            exchangeTable.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space3)
        ])
    }
    
    func setupStyles() {
        view.backgroundColor = Colors.offBlack.color
    }
}
extension ExchangesListViewController: UISearchTextFieldDelegate {
    
}

extension ExchangesListViewController: ExchangesListViewControllerProtocol {
    func displayList(exchangeList: [ExchangeCellViewModel]) {
        exchangeTable.exchangeList = exchangeList
        exchangeTable.tableView.reloadData()
    }
}
