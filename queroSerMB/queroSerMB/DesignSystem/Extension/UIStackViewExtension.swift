//
//  UIStackViewExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 26/10/23.
//

import UIKit

extension UIStackView {
    static func make(axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fillEqually, alignment: UIStackView.Alignment = .center, spacing: CGFloat = 4) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}
