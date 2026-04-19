//
//  MatchupMainPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/18/26.
//

import XCTest

struct MatchupMainPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = MatchupMainViewIdentifier
    
    @discardableResult
    func tapTab(_ tab: ContentPageTab) -> Self {
        let label = tab == .teams
        ? "Teams"
        : "Matchups"
        
        let tabButton = app.tabBars.buttons[label]
        tabButton.waitAndTap()
        
        return self
    }
    
    @discardableResult
    func verifyDisplayed() -> Self {
        let matchupView = app.scrollViews[Identifier.matchupView.rawValue]
        XCTAssertTrue(matchupView.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        return self
    }
    
    @discardableResult
    func verifyCompareButton(isEnabled: Bool) -> Self {
        let compareButton = app.buttons[Identifier.compareButton.rawValue]
        XCTAssertTrue(compareButton.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        XCTAssertEqual(compareButton.isEnabled, isEnabled)
        return self
    }
    
    @discardableResult
    func tapTeamSelectButton(for selectTeamButton: SelectTeamButton) -> TeamDropdownPage {
        let identifier: Identifier = selectTeamButton == .team1 ? Identifier.team1Button : Identifier.team2Button
        let button = app.buttons[identifier.rawValue]
        button.waitAndTap()
        
        return TeamDropdownPage(app: app)
    }
    
    @discardableResult
    func navigateBackToTeamsListPage() -> TeamListPage {
        let teamsTabButton = app.tabBars.buttons["Teams"]
        XCTAssertTrue(teamsTabButton.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        return TeamListPage(app: app)
    }
    
    @discardableResult
    func clearTeam(for selectTeamButton: SelectTeamButton) -> Self {
        let buttonIdentifier = selectTeamButton == .team1
        ? Identifier.team1Button
        : Identifier.team2Button
        
        let clear = app.buttons[buttonIdentifier.rawValue].buttons[Identifier.cancelButton.rawValue]
        clear.waitAndTap()

        XCTAssertFalse(clear.exists)
        
        return self
    }
    
    @discardableResult
    func tapCompareButton() -> MatchupMainPage {
        let compareButton = app.buttons[Identifier.compareButton.rawValue]
        XCTAssertTrue(compareButton.waitForExistence(timeout: UITestConstants.timeout.veryShort.rawValue))
        XCTAssertTrue(compareButton.isEnabled)
        
        compareButton.tap()
        return self
    }
    
    @discardableResult
    func verifyCompareSectionAppears() -> MatchupMainPage {
        let compareView = app.otherElements[TugOfWarViewIdentifier.tugOfWarChart.rawValue]
        XCTAssertTrue(compareView.waitForExistence(timeout: UITestConstants.timeout.standard.rawValue))
        return self
    }
    
    @discardableResult
    func tapFullGamesLink() -> FullGamesPage {
        let fullGamesLink = app.buttons[TugOfWarViewIdentifier.fullGamesListLink.rawValue]
        fullGamesLink.waitAndTap(timeout: UITestConstants.timeout.standard.rawValue)
        
        return FullGamesPage(app: app)
    }
    
    @discardableResult
    func tapHeadToHeadLink() -> HeadToHeadPage {
        let headToHeadLink = app.buttons[TugOfWarViewIdentifier.headToHeadResultsLink.rawValue]
        headToHeadLink.waitAndTap(timeout: UITestConstants.timeout.standard.rawValue)
        
        return HeadToHeadPage(app: app)
    }
}

enum SelectTeamButton {
    case team1
    case team2
}
