//
//  ExchangesListViewControllerSnapshotTests.swift
//  queroSerMBUITests
//
//  Created by Matheus Perez on 25/10/23.
//

import XCTest
import SnapshotTesting
import UIKit

@testable import queroSerMB

class ExchangesListViewControllerSnapshotTests: XCTestCase {
    
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()

        SnapshotTesting.isRecording = false
        SnapshotTesting.diffTool = "ksdiff"
        
        navigationController = UINavigationController()
    }
    
    func testExchangesListViewControllerSnapshot() {
        let viewController = ExchangesListFactory.make(navigationController: navigationController)
        
        _ = viewController.view
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone8), named: "ExchangesListViewController")
    }
}
