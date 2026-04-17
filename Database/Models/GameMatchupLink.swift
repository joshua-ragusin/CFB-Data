//
//  GameMatchupLink.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation
import GRDB

struct GameMatchupLink: Codable, Equatable {
    let gameID: UUID
    let matchupID: UUID
}

// MARK: - GRDB
extension GameMatchupLink: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case gameID, matchupID
    }
}
