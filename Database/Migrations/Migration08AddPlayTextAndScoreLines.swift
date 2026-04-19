//
//  Migration08AddPlayTextAndScoreLines.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

struct Migration08AddPlayTextAndScoreLines: Migration {
    var name: String { "v08" }
    
    func migrate(_ db: GRDB.Database) throws {
        try db.alter(table: "Game") { table in
            table.add(column: "homeLineScores", .text)
                .defaults(to: "")
            table.add(column: "awayLineScores", .text)
                .defaults(to: "")
        }
        
        try db.alter(table: "WinProbabilityPlay") { table in
            table.add(column: "playText", .text)
                .defaults(to: "")
        }
    }
}
