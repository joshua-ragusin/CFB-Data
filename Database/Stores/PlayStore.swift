//
//  PlayStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

class PlayStore: InjectionKey {
    static var currentValue = PlayStore()
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    func getPlay(by id: String) throws -> Play? {
        try queue.read { db in
            try Play
                .filter(Play.Column.id == id)
                .fetchOne(db)
        }
    }
    
    func savePlay(_ play: Play) throws {
        try queue.write { db in
            try play.save(db)
        }
    }
    
    func getPlays(for gameID: Int) throws -> [Play] {
        try queue.read { db in
            try Play
                .filter(Play.Column.gameID == gameID)
                .order(Play.Column.playNumber)
                .fetchAll(db)
        }
    }
    
    func getPlays(for driveID: String) throws -> [Play] {
        try queue.read { db in
            try Play
                .filter(Play.Column.driveID == driveID)
                .order(Play.Column.playNumber)
                .fetchAll(db)
        }
    }
}
