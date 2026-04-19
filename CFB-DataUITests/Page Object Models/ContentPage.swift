//
//  ContentPage.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/18/26.
//

import XCTest

struct ContentPage: Page {
    let app: XCUIApplication
    
    typealias Identifier = ContentViewIdentifier
    
//    func navigateTo(tab: ContentPageTab) -> Self
}

enum ContentPageTab {
    case teams
    case matchups
}
