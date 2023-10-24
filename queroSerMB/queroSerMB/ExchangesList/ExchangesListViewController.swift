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
    private lazy var exchangeTable = ExchangesTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        interactor.callServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private let interactor: ExchangesListInteractorProtocol
    
    init(interactor: ExchangesListInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        searchBar.delegate = self
        exchangeTable.exchangesDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExchangesListViewController: ViewSetup {
    func setupHierarchy() {
        view.addSubviews(searchBar, exchangeTable)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space2),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space3),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space3)
        ])
        
        NSLayoutConstraint.activate([
            exchangeTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Spacing.space3),
            exchangeTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            exchangeTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space3),
            exchangeTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space3)
        ])
    }
    
    func setupStyles() {
        view.backgroundColor = Colors.offBlack.color
        let backItem = UIBarButtonItem()
        backItem.title = "Voltar"
        navigationItem.backBarButtonItem = backItem
    }
}
extension ExchangesListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentText = textField.text, let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                interactor.filterExchanges(with: updatedText)
            }
            return true
        }
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            interactor.filterExchanges(with: "")
            return true
        }
}

extension ExchangesListViewController: ExchangesTableViewDelegate {
    func didTapExchange(at indexPath: IndexPath) {
        interactor.showDetails(indexPath: indexPath)
    }
}

extension ExchangesListViewController: ExchangesListViewControllerProtocol {
    func displayList(exchangeList: [ExchangeCellViewModel]) {
        exchangeTable.exchangeList = exchangeList
        exchangeTable.reloadData()
    }
}
