//
//  MatchupStoreTests.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

import XCTest
import GRDB

@testable import CFB_Data

class MatchupStoreTests: XCTestCase {
    @Injected(\.matchupStore) private var matchupStore
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    override func tearDownWithError() throws {
        try queue.write { db in
            try Matchup
                .deleteAll(db)
        }
    }
    
    func testSaveMatchup() throws {
        // Arrange
        let matchup1ID = UUID()
        let matchup2ID = UUID()
        
        let matchup1 = makeMatchup(id: matchup1ID)
        let matchup2 = makeMatchup(id: matchup2ID)
        
        
        // Act
        try matchupStore.saveMatchup(matchup1)
        try matchupStore.saveMatchup(matchup2)
        
        let actualMatchup1 = try queue.read { db in
            try Matchup
                .filter(Matchup.Columns.id == matchup1ID)
                .fetchOne(db)
        }
        
        let actualMatchup2 = try queue.read { db in
            try Matchup
                .filter(Matchup.Columns.id == matchup2ID)
                .fetchOne(db)
        }
        
        // Assert
        XCTAssertEqual(actualMatchup1, matchup1)
        XCTAssertEqual(actualMatchup2, matchup2)
    }
    
    func testGetMatchup_ByID() throws {
        // Arrange
        let matchup1ID = UUID()
        let matchup2ID = UUID()
        let unknownMatchupID = UUID()
        
        let matchup1 = makeMatchup(id: matchup1ID)
        let matchup2 = makeMatchup(id: matchup2ID)
        
        try queue.write { db in
            try matchup1.save(db)
            try matchup2.save(db)
        }
        
        // Act
        let actualMatchup1 = try matchupStore.getMatchup(by: matchup1ID)
        let actualMatchup2 = try matchupStore.getMatchup(by: matchup2ID)
        let actualUnknownMatchup = try matchupStore.getMatchup(by: unknownMatchupID)
        
        // Assert
        XCTAssertNil(actualUnknownMatchup)
        XCTAssertEqual(actualMatchup1, matchup1)
        XCTAssertEqual(actualMatchup2, matchup2)
    }
    
    func testGetMatchup_ByTeamNames() throws {
        // Arrange
        let team1Name = "Team 1"
        let team2Name = "Team 2"
        let team3Name = "Team 3"
        let team4Name = "Team 4"
        let otherTeamName = "Other Team"
        
        let matchup1 = makeMatchup(team1: team1Name, team2: team2Name)
        let matchup2 = makeMatchup(team1: team3Name, team2: team4Name)
        
        try queue.write { db in
            try matchup1.save(db)
            try matchup2.save(db)
        }
        
        // Act
        let actualMatchup1 = try matchupStore.getMatchup(for: team1Name, and: team2Name)
        let actualMatchup2 = try matchupStore.getMatchup(for: team3Name, and: team4Name)
        
        let reversedMatchup1 = try matchupStore.getMatchup(for: team2Name, and: team1Name)
        let reversedMatchup2 = try matchupStore.getMatchup(for: team4Name, and: team3Name)
        
        let unknownMatchup = try matchupStore.getMatchup(for: otherTeamName, and: team1Name)
        
        XCTAssertNil(unknownMatchup)
        
        XCTAssertEqual(actualMatchup1, matchup1)
        XCTAssertEqual(actualMatchup2, matchup2)
        
        XCTAssertEqual(reversedMatchup1, matchup1)
        XCTAssertEqual(reversedMatchup2, matchup2)
    }
    
    // MARK: - Private methods
    
    private func makeMatchup(
        id: UUID = UUID(),
        team1: String = "Team 1",
        team2: String = "Team 2",
        team1Wins: Int = 0,
        team2Wins: Int = 0,
        ties: Int = 0
    ) -> Matchup {
        Matchup(
            id: id,
            team1: team1,
            team2: team2,
            team1Wins: team1Wins,
            team2Wins: team2Wins,
            ties: ties
        )
    }
}
