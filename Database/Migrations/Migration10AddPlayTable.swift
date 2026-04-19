//
//  Migration10AddPlayTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

struct Migration10AddPlayTable: Migration {
    var name: String { "v10" }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.create(table: "Play") { table in
            table.column("id", .text)
                .notNull()
            table.column("driveID", .text)
                .references("Drive")
            table.column("gameID", .integer)
                .references("Game")
            table.column("driveNumber", .integer)
            table.column("playNumber", .integer)
            table.column("offense", .text)
            table.column("down", .integer)
                .notNull()
            table.column("distance", .integer)
                .notNull()
            table.column("yardLine", .integer)
                .notNull()
            table.column("playText", .text)
        }
    }
}
