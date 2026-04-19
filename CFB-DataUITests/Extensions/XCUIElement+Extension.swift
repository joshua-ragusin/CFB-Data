//
//  XCUIElement+Extension.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import XCTest

extension XCUIElement {
    // MARK: - Waiting
    func waitAndTap(timeout: TimeInterval = UITestConstants.timeout.veryShort.rawValue) {
        XCTAssertTrue(waitForExistence(timeout: timeout))
        tap()
    }
    
    func waitUntilEnabled(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "isEnabled == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
    }
    
    // MARK: - Text Entry
    
    func clearAndType(_ text: String) {
        tap()
        guard let current = value as? String, !current.isEmpty else {
            typeText(text)
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count)
        typeText(deleteString)
        typeText(text)
    }
    
    // MARK: - Cell Helpers
    
    var cellCount: Int {
        cells.count
    }

    func firstCell() -> XCUIElement {
        cells.firstMatch
    }
    
    func lastCell() -> XCUIElement {
        cells.element(boundBy: cells.count - 1)
    }
}
