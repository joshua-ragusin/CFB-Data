//
//  Migration05AddGameTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

import GRDB

struct Migration05AddGameTable: Migration {
    var name: String {
        "v05"
    }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.create(table: "Game") { table in
            table.column("id", .integer)
                .primaryKey()
            table.column("season", .integer)
                .notNull()
            table.column("seasonType", .text)
                .notNull()
            table.column("homeTeam", .text)
                .notNull()
            table.column("homePoints", .integer)
                .notNull()
            table.column("homeID", .integer)
                .references("Team")
            table.column("awayTeam", .text)
                .notNull()
            table.column("awayPoints", .integer)
                .notNull()
            table.column("awayID", .integer)
                .references("Team")
        }
    }
    
    
}
