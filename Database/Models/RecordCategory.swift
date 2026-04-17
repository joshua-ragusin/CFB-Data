//
//  RecordCategory.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation
import GRDB

struct RecordCategory: Codable, Equatable {
    let id: UUID
    let teamID: Int
    let games: Int
    let wins: Int
    let losses: Int
    let ties: Int
}

// MARK: GRDB
extension RecordCategory: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, teamID, games, wins, losses, ties
    }
}

// MARK: Computed Vars
extension RecordCategory {
    var displayString: String {
        if ties == 0 {
            return "\(wins) - \(losses)"
        } else {
            return "\(wins) - \(losses) - \(ties)"
        }
    }
}
