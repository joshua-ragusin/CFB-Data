//
//  DatabaseManager.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import Foundation
import GRDB

struct DatabaseManager {
    static internal var shared = DatabaseManager()
    
    let dbQueue: DatabaseQueue
    
    private init() {
        do {
            if !ProcessInfo.processInfo.isRunningUnitTests {
                let databasePath = try FileManager.default
                    .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appending(path: "db.sqlite")
                    .path()
                
                dbQueue = try DatabaseQueue(path: databasePath)
                print("SQLite DB Location: \(databasePath)")
            } else {
                dbQueue = try DatabaseQueue()
                print("SQLite DB Location: In-Memory")
            }
            
            try migrate()
        } catch {
            fatalError("Failed to open database: \(error)")
        }
    }
    
    internal func migrate() throws {
        var migrator = DatabaseMigrator()
        
        for migration in migrations {
            migrator.registerMigration(migration.name, migrate: migration.migrate)
        }
        
        try migrator.migrate(dbQueue)
    }
    
    internal var migrations: [Migration] {
        [
            Migration01AddTeamTable(),
            Migration02MatchupAndGamesTable(),
            Migration03AddRecordTables(),
            Migration04AddTeamLogoTable(),
            Migration05AddGameTable(),
            Migration06AddDateNotesAndNeutralSiteToGameTable()
        ]
    }
}

extension ProcessInfo {
    var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
