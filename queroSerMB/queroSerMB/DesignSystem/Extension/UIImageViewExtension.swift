//
//  UIImageViewExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 26/10/23.
//

import UIKit

extension UIImageView {
    static func make(contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
