//
//  MatchupStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/23/25.
//

import Foundation
import GRDB

class MatchupStore: InjectionKey {
    static var currentValue = MatchupStore()
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    func saveMatchup(_ matchup: Matchup) throws {
        _ = try queue.write { db in
            try matchup.save(db)
        }
    }
    
    func getMatchup(for team1: String, and team2: String) throws -> Matchup? {
        try queue.read { db in
            try Matchup
                .filter(Matchup.Columns.team1 == team1 || Matchup.Columns.team2 == team1)
                .filter(Matchup.Columns.team1 == team2 || Matchup.Columns.team2 == team2)
                .fetchOne(db)
        }
    }
    
    func getMatchup(by id: UUID) throws -> Matchup? {
        try queue.read { db in
            try Matchup
                .filter(Matchup.Columns.id == id)
                .fetchOne(db)
        }
    }
}
