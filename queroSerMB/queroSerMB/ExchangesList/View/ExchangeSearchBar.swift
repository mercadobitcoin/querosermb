//
//  ExchangeSearchBar.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

class ExchangeSearchBar: UISearchTextField {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Setup Methods
    private func setupView() {
        configureTextFieldAttributes()
        configureVisualAppearance()
        setCustomColors()
        setConstraints()
    }
    
    private func configureTextFieldAttributes() {
        keyboardType = .webSearch
        autocorrectionType = .no
        setPlaceholder("Busque um ativo", withColor: Colors.white.color)
    }
    
    private func configureVisualAppearance() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        textColor = Colors.white.color
        tintColor = Colors.white.color
        layer.borderColor = Colors.white.color.cgColor
        backgroundColor = Colors.offBlack.color
    }
    
    private func setCustomColors() {
        setMagnifyingGlassColor(to: Colors.white.color)
        setClearButtonColor(to: Colors.white.color)
    }
    
    private func setConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
