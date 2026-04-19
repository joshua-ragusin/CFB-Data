//
//  HeadToHeadPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/18/26.
//

import XCTest

struct HeadToHeadPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = HeadToHeadChartViewIdentifier
    
    @discardableResult
    func verifyAppearance() -> Self {
        let chart = app.otherElements[Identifier.headToHeadChart.rawValue]
        XCTAssertTrue(chart.waitForExistence(timeout: UITestConstants.timeout.standard.rawValue))
        return self
    }
    
    @discardableResult
    func navigateBack() -> MatchupMainPage {
        app.navigationBars.buttons.firstMatch.tap()
        return MatchupMainPage(app: app)
    }
}
