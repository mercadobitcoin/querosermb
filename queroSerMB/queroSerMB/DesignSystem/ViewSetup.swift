//
//  ViewSetup.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

protocol ViewSetup {
    func buildView()
    func setupConstraints()
    func setupHierarchy()
    func setupStyles()
}

extension ViewSetup where Self: UIView {
    func buildView() {
        setupHierarchy()
        setupConstraints()
        setupStyles()
    }
    
    func setupStyles() { }
}

extension ViewSetup where Self: UIViewController {
    func buildView() {
        setupHierarchy()
        setupConstraints()
        setupStyles()
    }
    
    func setupStyles() { }
}
