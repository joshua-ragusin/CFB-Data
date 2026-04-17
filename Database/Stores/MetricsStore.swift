//
//  MetricsStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation
import GRDB

class MetricsStore: InjectionKey {
    static var currentValue = MetricsStore()
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    // MARK: Win Probability Play Metrics
    
    func saveWinProbabilityPlay(_ metric: WinProbabilityPlay) throws {
        try queue.write { db in
            try metric.save(db)
        }
    }
    
    func getWinProbabilityPlays(for gameID: Int) throws -> [WinProbabilityPlay] {
        try queue.read { db in
            try WinProbabilityPlay
                .filter(WinProbabilityPlay.Columns.gameID == gameID)
                .fetchAll(db)
        }
    }
    
    func getWinProbabilityPlay(for gameID: Int, playNumber: Int) throws -> WinProbabilityPlay? {
        try queue.read { db in
            try WinProbabilityPlay
                .filter(WinProbabilityPlay.Columns.gameID == gameID)
                .filter(WinProbabilityPlay.Columns.playNumber == playNumber)
                .fetchOne(db)
        }
    }
}
