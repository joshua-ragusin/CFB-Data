//
//  Drive.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

struct Drive: Codable, Identifiable {
    let id: String
    let gameID: Int
    let driveNumber: Int
    let plays: Int
    let yards: Int
    let isHomeOffense: Bool
    let driveResult: String
    
    var groupedPlays: [WinProbabilityPlay] = []
    
    enum CodingKeys: String, CodingKey {
        case id, gameID, driveNumber, plays, yards, isHomeOffense, driveResult
    }
}

extension Drive: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, gameID, driveNumber, plays, yards, isHomeOffense, driveResult
    }
}

extension Drive {
    var driveHeaderTitle: String {
        groupedPlays.last?.playText ?? ""
    }
}
