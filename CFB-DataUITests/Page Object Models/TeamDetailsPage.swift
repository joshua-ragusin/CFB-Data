//
//  TeamDetailsPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import XCTest

struct TeamDetailsPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = TeamDetailsViewIdentifier
    
    @discardableResult
    func verifyIsDisplayed() -> Self {
        let seasonList = app.scrollViews[Identifier.seasonList.rawValue]
        XCTAssertTrue(seasonList.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        return self
    }
    
    @discardableResult
    func navigateBack() -> TeamListPage {
        app.tapBackButton()
        return TeamListPage(app: app)
    }
}
