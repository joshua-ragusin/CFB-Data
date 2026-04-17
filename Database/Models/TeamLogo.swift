//
//  TeamLogo.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation
import GRDB

struct TeamLogo: Codable, Identifiable, Equatable {
    let id: UUID
    let teamID: Int
    let logoData: Data
    
    enum CodingKeys: String, CodingKey {
        case id, teamID, logoData
    }
}

// MARK: GRDB
extension TeamLogo: PersistableRecord, FetchableRecord {
    enum Columns: String, ColumnExpression {
        case id, teamID, logoData
    }
}
