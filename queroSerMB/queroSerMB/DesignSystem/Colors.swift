//
//  Colors.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

enum Colors {
    case white
    case offBlack
    case offGray
    case red
    
    var color: UIColor {
        switch self {
        case .white:
            return UIColor(red: 0.99, green: 1.00, blue: 1.00, alpha: 1.00)
        case .offBlack:
            return UIColor(red: 0.07, green: 0.07, blue: 0.08, alpha: 1.00)
        case .offGray:
            return UIColor(red: 0.11, green: 0.12, blue: 0.13, alpha: 1.00)
        case .red:
            return UIColor(red: 0.62, green: 0.48, blue: 0.52, alpha: 1.00)
        }
    }
}
