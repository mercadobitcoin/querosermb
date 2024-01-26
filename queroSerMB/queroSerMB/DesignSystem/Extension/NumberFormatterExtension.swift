//
//  NumberFormatterExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

extension NumberFormatter {
    static let financial: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    func string(fromValue value: Double) -> String {
        switch value {
        case 1_000_000_000_000...:
            return "\(string(from: NSNumber(value: value/1_000_000_000_000)) ?? "0") T"
        case 1_000_000_000...:
            return "\(string(from: NSNumber(value: value/1_000_000_000)) ?? "0") B"
        case 1_000_000...:
            return "\(string(from: NSNumber(value: value/1_000_000)) ?? "0") M"
        case 1_000...:
            return "\(string(from: NSNumber(value: value/1_000)) ?? "0") K"
        default:
            return string(from: NSNumber(value: value)) ?? "0"
        }
    }
}
