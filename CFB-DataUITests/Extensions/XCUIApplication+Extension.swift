//
//  XCUIApplication+Extension.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import XCTest

extension XCUIApplication {
    // MARK: - Navigation
    
    func tapBackButton() {
        navigationBars.buttons.firstMatch.tap()
    }
    
    func navigateBack(times: Int = 1) {
        (0..<times).forEach { _ in tapBackButton() }
    }
    
    func switchToTab(named tab: String) {
        tabs.buttons[tab].firstMatch.tap()
    }
}
