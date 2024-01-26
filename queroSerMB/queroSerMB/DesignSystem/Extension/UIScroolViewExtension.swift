//
//  UIScroolViewExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 26/10/23.
//

import UIKit

extension UIScrollView {
    static func make() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }
}
