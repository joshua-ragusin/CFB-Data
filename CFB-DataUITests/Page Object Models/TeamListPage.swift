//
//  TeamListPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import XCTest

struct TeamListPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = TeamListViewIdentifier
    
    private let searchBarPlaceholder = "Search"
    
    @discardableResult
    func searchForTeamExpectingResult(_ team: String) -> Self {
        let teamList = app.collectionViews[Identifier.teamList.rawValue]
        
        if !isSearchBarCurrentlyVisible() {
            teamList.swipeDown()
        }
        
        let searchField = app.searchFields[searchBarPlaceholder]
        searchField.clearAndType(team)
        return self
    }
    
    @discardableResult
    func searchForTeamExpectingNothing(_ term: String = "zzzzzzzzz") -> Self {
        let teamList = app.collectionViews[Identifier.teamList.rawValue]
        
        if !isSearchBarCurrentlyVisible() {
            teamList.swipeDown()
        }
        
        let searchField = app.searchFields[searchBarPlaceholder]
        searchField.clearAndType(term)

        let noResults = app.images[Identifier.noResults.rawValue]
        XCTAssertTrue(noResults.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        
        app.buttons["Cancel"].tap()
        return self
    }
    
    @discardableResult
    func verifyTeamsAreDisplayed(count: Int? = nil) -> Self {
        let teamList = app.collectionViews[Identifier.teamList.rawValue]
        
        if let count {
            XCTAssertEqual(teamList.cellCount, count)
        } else {
            XCTAssertGreaterThan(teamList.cellCount, 0)
        }
        
        XCTAssertTrue(!app.otherElements[Identifier.noResults.rawValue].exists)
        
        return self
    }
    
    @discardableResult
    func clearSearchBarText() -> Self {
        let teamList = app.collectionViews[Identifier.teamList.rawValue]
        
        if !isSearchBarCurrentlyVisible() {
            teamList.swipeDown()
        }
        
        let searchField = app.searchFields[searchBarPlaceholder]
        searchField.clearAndType("")
        app.buttons["Cancel"].tap()

        return self
    }
    
    @discardableResult
    func tapOnTeamCell(_ team: String) -> TeamDetailsPage {
        let teamList = app.collectionViews[Identifier.teamList.rawValue]
        let teamCell = teamList.cells.containing(.staticText, identifier: team).firstMatch
        XCTAssertTrue(teamCell.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        teamCell.tap()
        return TeamDetailsPage(app: app)
    }
    
    private func isSearchBarCurrentlyVisible() -> Bool {
        app.searchFields[searchBarPlaceholder].waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue)
    }
}
