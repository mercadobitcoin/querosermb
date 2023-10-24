//
//  DoubleExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 24/10/23.
//

import Foundation

extension Double {
    func currencyFormatter() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString
        } else {
            return ""
        }
    }
}
