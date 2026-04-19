//
//  MatchupMainViewTests.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/18/26.
//

import XCTest

class MatchupMainViewTests: XCTestCase {
    var app: XCUIApplication!
    
    private static var isLaunched = false
    
    override func setUp() {
        app = XCUIApplication()

        if !MatchupMainViewTests.isLaunched {
            app.launch()
            MatchupMainViewTests.isLaunched = true
        }
    }
    
    func testTeamSelectionFlow() throws {
        MatchupMainPage(app: app)
            .tapTab(.matchups)
            .verifyDisplayed()
            .verifyCompareButton(isEnabled: false)
            .verifyTeamDropdownNavigation(for: .team1)
            .tapTeamCellWhenEmpty("Alabama")
            .verifyTeamDropdownNavigation(for: .team2)
            .tapTeamCellWhenEmpty("Auburn")
            .verifyCompareButton(isEnabled: true)
            .clearTeam(for: .team1)
            .verifyCompareButton(isEnabled: false)
            .clearTeam(for: .team2)
            .navigateBackToTeamsListPage()
    }
    
    // Test compareview flow (selection + appearance + navigation)
    func testTeamCompareFlow() throws {
        MatchupMainPage(app: app)
            .tapTab(.matchups)
            .verifyDisplayed()
            .verifyCompareButton(isEnabled: false)
            .verifyTeamDropdownNavigation(for: .team1)
            .tapTeamCellWhenEmpty("Alabama")
            .verifyTeamDropdownNavigation(for: .team2)
            .tapTeamCellWhenEmpty("Auburn")
            .verifyCompareButton(isEnabled: true)
            .tapCompareButton()
            .verifyCompareSectionAppears()
            .verifyFullGamesListNavigation()
            .verifyAppearance()
            .navigateBack()
            .verifyHeadToHeadNavigation()
            .verifyAppearance()
            .navigateBack()
            .clearTeam(for: .team1)
            .clearTeam(for: .team2)
            .navigateBackToTeamsListPage()
    }
}
