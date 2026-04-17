//
//  GameStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/23/25.
//
import GRDB
import Foundation

class GameStore: InjectionKey {
    static var currentValue = GameStore()
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    // MARK: - Matchup Games
    
    func saveMatchupGame(_ game: MatchupGame) throws {
        try queue.write { db in
            try game.save(db)
        }
    }
    
    func saveGameMatchupLink(_ link: GameMatchupLink) throws {
        try queue.write { db in
            try link.save(db)
        }
    }
    
    func getGameMatchupLinks(for matchupID: UUID) throws -> [GameMatchupLink] {
        try queue.read { db in
            try GameMatchupLink
                .filter(GameMatchupLink.Columns.matchupID == matchupID)
                .fetchAll(db)
        }
    }
    
    func getMatchupGames(for matchupID: UUID) throws -> [MatchupGame] {
        let matchupLinks = try getGameMatchupLinks(for: matchupID)
        
        var games = [MatchupGame]()
        
        for link in matchupLinks {
            if let game = try? getMatchupGame(by: link.gameID) {
                games.append(game)
            }
        }
        
        return games
    }
    
    func getMatchupGame(by id: UUID) throws -> MatchupGame? {
        try queue.read { db in
            try MatchupGame
                .filter(MatchupGame.Columns.id == id)
                .fetchOne(db)
        }
    }
    
    // MARK: - Game
    
    func getGame(by id: Int) throws -> Game? {
        try queue.read { db in
            try Game
                .filter(Game.Columns.id == id)
                .fetchOne(db)
        }
    }
    
    func saveGame(_ game: Game) throws {
        try queue.write { db in
            try game.save(db)
        }
    }
    
    func getGames(for teamID: Int, in year: Int) throws -> [Game] {
        try queue.read { db in
            try Game
                .filter(Game.Columns.season == year)
                .filter(Game.Columns.awayID == teamID || Game.Columns.homeID == teamID)
                .order(Game.Columns.dateString)
                .fetchAll(db)
        }
    }
}
