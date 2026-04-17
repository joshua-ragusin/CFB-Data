//
//  Migration04AddTeamLogoTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import GRDB

struct Migration04AddTeamLogoTable: Migration {
    var name: String { "v04" }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.create(table: "TeamLogo") { table in
            table.column("id", .text)
                .primaryKey()
            table.column("teamID", .integer)
                .notNull()
                .references("Team")
            table.column("logoData", .blob)
                .notNull()
        }
    }
}
