//
//  Migration02MatchupAndGamesTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/23/25.
//
import GRDB

struct Migration02MatchupAndGamesTable: Migration {
    var name: String { "v02" }
    
    func migrate(_ db: GRDB.Database) throws {
        try addGameTable(db: db)
        try addMatchupTable(db: db)
        try addGameMatchupLinkTable(db: db)
    }
    
    private func addGameMatchupLinkTable(db: GRDB.Database) throws {
        try db.create(table: "GameMatchupLink") { table in
            table.column("gameID", .text)
                .notNull()
                .references("MatchupGame")
            table.column("matchupID", .text)
                .notNull()
                .references(("Matchup"))
            table.primaryKey(["gameID", "matchupID"])
        }
    }
    
    private func addGameTable(db: GRDB.Database) throws {
        try db.create(table: "MatchupGame") { table in
            table.column("id", .text)
                .primaryKey()
            table.column("season", .integer)
                .notNull()
            table.column("week", .integer)
                .notNull()
            table.column("date", .text)
                .notNull()
            table.column("homeTeam", .text)
                .notNull()
            table.column("awayTeam", .text)
                .notNull()
            table.column("homeScore", .integer)
                .notNull()
            table.column("awayScore", .integer)
                .notNull()
        }
    }
    
    private func addMatchupTable(db: GRDB.Database) throws {
        try db.create(table: "Matchup") { table in
            table.column("id", .text)
                .primaryKey()
            table.column("team1", .text)
                .notNull()
            table.column("team2", .text)
                .notNull()
            table.column("team1Wins", .integer)
                .notNull()
            table.column("team2Wins", .integer)
                .notNull()
            table.column("ties", .integer)
                .notNull()
        }
    }
}
