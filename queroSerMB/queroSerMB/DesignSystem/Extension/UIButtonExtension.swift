//
//  UIButtonExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 26/10/23.
//

import UIKit

extension UIButton {
    static func make(title: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
