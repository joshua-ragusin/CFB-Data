//
//  Migration06AddDateToGameTable.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/30/26.
//

import GRDB

struct Migration06AddDateNotesAndNeutralSiteToGameTable: Migration {
    var name: String { "v06" }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.alter(table: "Game") { table in
            table.add(column: "date", .text)
                .notNull()
                .defaults(to: "")
            
            table.add(column: "notes", .text)
            
            table.add(column: "neutralSite", .boolean)
                .notNull()
                .defaults(to: false)
        }
    }
    
}
