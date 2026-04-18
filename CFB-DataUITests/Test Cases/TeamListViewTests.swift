//
//  TeamListViewTests.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import XCTest

class TeamListViewTests: XCTestCase {
    var app: XCUIApplication!
    
    private static var isLaunched = false
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        
        if !TeamListViewTests.isLaunched {
            app.launch()
            TeamListViewTests.isLaunched = true
        }
    }
    
    func testTeamListSearchFlow() {
        TeamListPage(app: app)
            .verifyTeamsAreDisplayed()
            .searchForTeamExpectingResult("California")
            .verifyTeamsAreDisplayed(count: 1)
            .searchForTeamExpectingNothing()
            .clearSearchBarText()
    }
    
    func testTeamListNavigationFlow() {
        TeamListPage(app: app)
            .verifyTeamsAreDisplayed()
            .tapOnTeamCell("Alabama")
            .verifyTeamDetailsViewIsDisplayed()
    }
}
