//
//  DriveStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

class DriveStore: InjectionKey {
    static var currentValue = DriveStore()
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    func getDrive(id: String) throws -> Drive? {
        try queue.read { db in
            try Drive
                .filter(Drive.Columns.id == id)
                .fetchOne(db)
        }
    }
    
    func getDrives(for gameID: Int) throws -> [Drive] {
        try queue.read { db in
            try Drive
                .filter(Drive.Columns.gameID == gameID)
                .fetchAll(db)
        }
    }
    
    func saveDrive(_ drive: Drive) throws {
        try queue.write { db in
            try drive.save(db)
        }
    }
}
