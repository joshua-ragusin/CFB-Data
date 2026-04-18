//
//  GameStoreTests.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/28/26.
//

import XCTest
import GRDB

@testable import CFB_Data

class GameStoreTests: XCTestCase {
    @Injected(\.gameStore) private var gameStore
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    override func tearDownWithError() throws {
        try queue.write { db in
            try GameMatchupLink
                .deleteAll(db)
            
            try MatchupGame
                .deleteAll(db)
        }
    }
    
    func testSaveGame() throws {
        // Arrange
        let firstGameID = UUID()
        let secondGameID = UUID()
        
        let firstGame = makeGame(id: firstGameID, season: 1, week: 1)
        let secondGame = makeGame(id: secondGameID, season: 2, week: 1)
        
        // Act
        try gameStore.saveMatchupGame(firstGame)
        try gameStore.saveMatchupGame(secondGame)
        
        // Assert
        let actualFirstGame = try queue.read { db in
            try MatchupGame
                .filter(MatchupGame.Columns.id == firstGameID)
                .fetchOne(db)
        }
        
        let actualSecondGame = try queue.read { db in
            try MatchupGame
                .filter(MatchupGame.Columns.id == secondGameID)
                .fetchOne(db)
        }
        
        XCTAssertNotNil(actualFirstGame)
        XCTAssertNotNil(actualSecondGame)

        XCTAssertEqual(firstGame, actualFirstGame)
        XCTAssertEqual(secondGame, actualSecondGame)
    }
    
    func testGetGameByID() throws {
        // Arrange
        let existingGameID = UUID()
        let nonExistingGameID = UUID()
        
        let existingGame = makeGame(id: existingGameID)
        
        try queue.write { db in
            try existingGame.insert(db)
        }
        
        // Act
        let actualExistingGame = try gameStore.getMatchupGame(by: existingGameID)
        let actualNonExistingGame = try gameStore.getMatchupGame(by: nonExistingGameID)
        
        // Assert
        XCTAssertNil(actualNonExistingGame)
        XCTAssertNotNil(actualExistingGame)
        
        XCTAssertEqual(existingGame, actualExistingGame)
    }
    
    func testSaveGameMatchupLinks() throws {
        // Arrange
        let game1ID = UUID()
        let game2ID = UUID()
        let matchup1ID = UUID()
        let matchup2ID = UUID()
        
        let gameMatchupLink1 = makeGameMatchupLink(gameID: game1ID, matchupID: matchup1ID)
        let gameMatchupLink2 = makeGameMatchupLink(gameID: game2ID, matchupID: matchup2ID)
        
        try insertGame(with: game1ID)
        try insertGame(with: game2ID)
        try insertMatchup(with: matchup1ID)
        try insertMatchup(with: matchup2ID)

        // Act
        try gameStore.saveGameMatchupLink(gameMatchupLink1)
        try gameStore.saveGameMatchupLink(gameMatchupLink2)
        
        // Assert
        let actualGameMatchupLink1 = try queue.read { db in
            try GameMatchupLink
                .filter(GameMatchupLink.Columns.gameID == game1ID)
                .filter(GameMatchupLink.Columns.matchupID == matchup1ID)
                .fetchOne(db)
        }
        
        let actualGameMatchupLink2 = try queue.read { db in
            try GameMatchupLink
                .filter(GameMatchupLink.Columns.gameID == game2ID)
                .filter(GameMatchupLink.Columns.matchupID == matchup2ID)
                .fetchOne(db)
        }
        
        XCTAssertNotNil(actualGameMatchupLink1)
        XCTAssertNotNil(actualGameMatchupLink2)
        
        XCTAssertEqual(gameMatchupLink1, actualGameMatchupLink1)
        XCTAssertEqual(gameMatchupLink2, actualGameMatchupLink2)
    }
    
    func testGetGameMathcupLinks() throws {
        // Arrange
        let game1ID = UUID()
        let game2ID = UUID()
        let matchupID = UUID()
        
        try insertGame(with: game1ID) // try gameStore.saveGame()
        try insertGame(with: game2ID)
        try insertMatchup(with: matchupID)
        
        let matchupLink1 = makeGameMatchupLink(gameID: game1ID, matchupID: matchupID)
        let matchupLink2 = makeGameMatchupLink(gameID: game2ID, matchupID: matchupID)
        
        try queue.write { db in
            try matchupLink1.save(db)
            try matchupLink2.save(db)
        }
        
        // Act
        let actualMatchupLinks = try gameStore.getGameMatchupLinks(for: matchupID)
        
        // Assert
        XCTAssertEqual(actualMatchupLinks.count, 2)
        XCTAssert(actualMatchupLinks.contains(matchupLink1))
        XCTAssert(actualMatchupLinks.contains(matchupLink2))
    }
    
    func testGetGameMatchupLinks_ReturnsEmpyListWhenNoLinksExist() throws {
        // Arrange
        let matchupID = UUID()
        
        // Act
        let actualMatchupLinks = try gameStore.getGameMatchupLinks(for: matchupID)
        
        // Assert
        XCTAssertEqual(actualMatchupLinks.count, 0)
    }
    
    func testGetGamesByMatchup() throws {
        // Arrange
        let matchup1ID = UUID()
        let matchup2ID = UUID()
        
        let matchup1Games = (1...5).map { makeGame(week: $0) }
        let matchup2Games = (5...10).map { makeGame(week: $0) }
        
        let matchup1Links = matchup1Games.map { makeGameMatchupLink(gameID: $0.id, matchupID: matchup1ID) }
        let matchup2Links = matchup2Games.map { makeGameMatchupLink(gameID: $0.id, matchupID: matchup2ID) }
        
        try insertMatchup(with: matchup1ID)
        try insertMatchup(with: matchup2ID)
        
        try queue.write { db in
            for game in matchup1Games {
                try game.save(db)
            }
            
            for game in matchup2Games {
                try game.save(db)
            }
            
            for matchup in matchup1Links {
                try matchup.save(db)
            }
            
            for matchup in matchup2Links {
                try matchup.save(db)
            }
        }
        
        // Act
        let actualMatchup1Games = try gameStore.getMatchupGames(for: matchup1ID)
        let actualMatchup2Games = try gameStore.getMatchupGames(for: matchup2ID)
        
        // Assert
        XCTAssertEqual(actualMatchup1Games.count, matchup1Games.count)
        XCTAssertEqual(actualMatchup2Games.count, matchup2Games.count)
        
        XCTAssertEqual(actualMatchup1Games, matchup1Games)
        XCTAssertEqual(actualMatchup2Games, matchup2Games)
    }
    
    func testGetGamesByMatchup_ReturnsEmptyArrayIfNoMatchup() throws {
        // Arrange
        let matchupID = UUID()
        
        // Act
        let actualMatchups = try gameStore.getMatchupGames(for: matchupID)
        
        // Assert
        XCTAssertEqual(actualMatchups, [])
    }
    
    // MARK: - Private helpers
    
    private func makeGame(
        id: UUID = UUID(),
        season: Int = 1,
        week: Int = 1,
        dateString: String = "",
        homeTeam: String = "",
        awayTeam: String = "",
        homeScore: Int = 0,
        awayScore: Int = 0
    ) -> MatchupGame {
        MatchupGame(id: id,
             season: season,
             week: week,
             dateString: dateString,
             homeTeam: homeTeam,
             awayTeam: awayTeam,
             homeScore: homeScore,
             awayScore: awayScore
        )
    }
    
    private func makeMatchup(
        id: UUID = UUID(),
        team1: String = "",
        team2: String = "",
        team1Wins: Int = 0,
        team2Wins: Int = 0,
        ties: Int = 0
    ) -> Matchup {
        Matchup(id: id,
                team1: team1,
                team2: team2,
                team1Wins: team1Wins,
                team2Wins: team2Wins,
                ties: ties)
    }
    
    private func makeGameMatchupLink(
        gameID: UUID,
        matchupID: UUID
    ) -> GameMatchupLink {
        GameMatchupLink(gameID: gameID,
                        matchupID: matchupID
        )
    }
    
    private func insertGame(with id: UUID) throws {
        try queue.write { db in
            try makeGame(id: id).insert(db)
        }
    }
    
    private func insertMatchup(with id: UUID) throws {
        try queue.write { db in
            try makeMatchup(id: id).insert(db)
        }
    }
}
