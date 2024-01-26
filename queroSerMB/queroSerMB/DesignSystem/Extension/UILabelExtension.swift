//
//  UILabelExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 26/10/23.
//

import UIKit

extension UILabel {
    static func make(font: UIFont = UIFont.systemFont(ofSize: 16), text: String? = nil, textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textAlignment = textAlignment
        label.textColor = Colors.white.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        return label
    }
}
