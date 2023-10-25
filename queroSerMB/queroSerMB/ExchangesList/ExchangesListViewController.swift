//
//  ExchangesListViewController.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

// MARK: - Protocols
protocol ExchangesListViewControllerProtocol: AnyObject {
    func displayList(exchangeList: [ExchangeCellViewModel])
}

// MARK: - Main Class
class ExchangesListViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var searchBar: ExchangeSearchBar = {
        let searchBar = ExchangeSearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var exchangeTable: ExchangesTableView = {
        let table = ExchangesTableView()
        table.exchangesDelegate = self
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private let interactor: ExchangesListInteractorProtocol
    
    // MARK: - Initializers
    init(interactor: ExchangesListInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
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
}

// MARK: - ViewSetup
extension ExchangesListViewController: ViewSetup {
    func setupHierarchy() {
        view.addSubviews(activityIndicator, searchBar, exchangeTable)
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
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupStyles() {
        view.backgroundColor = Colors.offBlack.color
        let backItem = UIBarButtonItem()
        backItem.title = "Voltar"
        navigationItem.backBarButtonItem = backItem
        
        exchangeTable.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        exchangeTable.isHidden = false
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITextFieldDelegate
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

// MARK: - ExchangesTableViewDelegate
extension ExchangesListViewController: ExchangesTableViewDelegate {
    func didTapExchange(at indexPath: IndexPath) {
        interactor.showDetails(indexPath: indexPath)
    }
}

// MARK: - ExchangesListViewControllerProtocol
extension ExchangesListViewController: ExchangesListViewControllerProtocol {
    func displayList(exchangeList: [ExchangeCellViewModel]) {
        exchangeTable.exchangeList = exchangeList
        exchangeTable.reloadData()
        stopLoading()
    }
}
