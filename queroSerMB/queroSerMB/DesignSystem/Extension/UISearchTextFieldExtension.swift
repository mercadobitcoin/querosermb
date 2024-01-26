//
//  UISearchTextFieldExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

extension UISearchTextField {
    func setMagnifyingGlassColor(to color: UIColor) {
        if let glassIconView = leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = color
        }
    }
    
    func setPlaceholder(_ text: String, withColor color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: self.font ?? UIFont.systemFont(ofSize: 14)
        ]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
    
    func setClearButtonColor(to color: UIColor) {
        if let clearButton = self.value(forKey: "clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = color
        }
    }
}
