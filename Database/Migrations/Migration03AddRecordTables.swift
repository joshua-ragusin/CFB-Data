//
//  Migration03AddRecordTables.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import GRDB

struct Migration03AddRecordTables: Migration {
    func migrate(_ db: GRDB.Database) throws {
        try createRecordCategoryTable(db)
        try createRecordTable(db)
    }
    
    var name: String { "v03" }
    
    private func createRecordTable(_ db: GRDB.Database) throws {
        try db.create(table: "Record") { table in
            table.column("id", .text)
                .primaryKey()
            table.column("teamID", .integer)
                .notNull()
                .indexed()
                .references("Team", onDelete: .cascade, onUpdate: .cascade)
            table.column("year", .integer)
                .notNull()
            table.column("team", .text)
                .notNull()
            table.column("conference", .text)
                .notNull()
            table.column("conferenceRecordID", .text)
                .notNull()
                .references("RecordCategory")
            table.column("totalRecordID", .text)
                .notNull()
                .references("RecordCategory")
        }
    }
    
    private func createRecordCategoryTable(_ db: GRDB.Database) throws {
        try db.create(table: "RecordCategory") { table in
            table.column("id")
                .primaryKey()
            table.column("teamID")
                .notNull()
                .indexed()
                .references("Team")
            table.column("games", .integer)
                .notNull()
            table.column("wins", .integer)
                .notNull()
            table.column("losses", .integer)
                .notNull()
            table.column("ties", .integer)
        }
    }
}

//let id = UUID()
//let teamID: Int
//let games: Int
//let wins: Int
//let losses: Int
//let ties: Int
