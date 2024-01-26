//
//  UITableViewExtension.swift
//  queroSerMB
//
//  Created by Matheus Perez on 21/10/23.
//

import UIKit

extension UITableView {
    func isCellCompletelyVisible(at indexPath: IndexPath) -> Bool {
        let cellRect = self.rectForRow(at: indexPath)
        return self.bounds.contains(cellRect)
    }
}
