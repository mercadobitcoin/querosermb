//
//  ExchangeSearchBar.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

class ExchangeSearchBar: UISearchTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        keyboardType = .webSearch
        autocorrectionType = .no
        setPlaceholder("Busque um ativo", withColor: Colors.white.color)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        textColor = Colors.white.color
        tintColor = Colors.white.color
        layer.borderColor = Colors.white.color.cgColor
        backgroundColor = Colors.offBlack.color
        setMagnifyingGlassColor(to: Colors.white.color)
        setClearButtonColor(to: Colors.white.color)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
