//
//  Migration09AddDriveTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

struct Migration09AddDriveTable: Migration {
    var name: String { "v09" }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.create(table: "Drive") { table in
            table.column("id", .text)
                .primaryKey()
            table.column("gameID", .integer)
                .references("Game")
            table.column("driveNumber", .integer)
            table.column("plays", .integer)
            table.column("yards", .integer)
            table.column("isHomeOffense", .boolean)
            table.column("driveResult", .text)
        }
    }
    
    
}
