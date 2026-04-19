//
//  TeamDropdownPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/18/26.
//

import XCTest

struct TeamDropdownPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = TeamDropdownViewIdentifier
    
    @discardableResult
    func verifyViewAppears() -> Self {
        let teamList = app.collectionViews[Identifier.teamList.rawValue]
        
        XCTAssertTrue(teamList.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        return self
    }
    
    @discardableResult
    func tapTeamCellWhenEmpty(_ team: String) -> MatchupMainPage {
        let cell = app.staticTexts[team]
        XCTAssertTrue(cell.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        cell.tap()
        return MatchupMainPage(app: app)
    }
    
    @discardableResult
    func tapTeamCellWhenNotEmpty(_ team: String) -> Self {
        let cell = app.collectionViews.cells.matching(.staticText, identifier: team).firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        cell.tap()
        return self
    }
    
    @discardableResult
    func navigateBack() -> MatchupMainPage {
        app.tapBackButton()
        return MatchupMainPage(app: app)
    }
}
