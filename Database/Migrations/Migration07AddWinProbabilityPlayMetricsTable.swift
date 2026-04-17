//
//  Migration07AddWinProbabilityPlayMetricsTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import GRDB

struct Migration07AddWinProbabilityPlayMetricsTable: Migration {
    var name: String { "v07" }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.create(table: "WinProbabilityPlay") { table in
            table.autoIncrementedPrimaryKey("id")
            table.column("gameID", .integer).notNull().references("Game")
            table.column("home", .text).notNull()
            table.column("away", .text).notNull()
            table.column("homeWinProbability", .double).notNull()
            table.column("playNumber", .integer).notNull()
            table.column("yardLine", .integer)
            table.column("down", .integer)
            table.column("distance", .integer)
        }
    }
}
