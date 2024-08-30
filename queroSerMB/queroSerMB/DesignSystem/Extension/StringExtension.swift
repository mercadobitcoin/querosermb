//
//  StringExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 23/10/23.
//

import Foundation

extension String {
    func currencyFormatter(value: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return formattedString
        } else {
            return ""
        }
    }
}
