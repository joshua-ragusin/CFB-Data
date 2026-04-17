//
//  Migration01AddTeamTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import GRDB

struct Migration01AddTeamTable: Migration {
    func migrate(_ db: GRDB.Database) throws {
        try db.create(table: "Team") { table in
            table.column("id", .integer).primaryKey()
            table.column("school", .text).notNull()
            table.column("mascot", .text).notNull()
            table.column("conference", .text).notNull()
            table.column("color", .text).notNull()
            table.column("logos", .text).notNull()
        }
    }
    
    var name: String { "v01" }
}
