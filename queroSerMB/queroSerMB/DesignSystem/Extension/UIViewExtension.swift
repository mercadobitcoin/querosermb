//
//  UIViewExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
