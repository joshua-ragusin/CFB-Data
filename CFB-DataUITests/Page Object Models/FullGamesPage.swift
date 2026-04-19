//
//  FullGamesPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/18/26.
//

import XCTest

struct FullGamesPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = FullGameViewIdentifier
    
    @discardableResult
    func verifyAppearance() -> FullGamesPage {
        let gamesList = app.collectionViews[Identifier.gamesList.rawValue]
        XCTAssertTrue(gamesList.waitForExistence(timeout: UITestConstants.timeout.standard.rawValue))
        return self
    }
    
    @discardableResult
    func navigateBack() -> MatchupMainPage {
        app.navigateBack()
        return MatchupMainPage(app: app)
    }
}
