//
//  Play.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import GRDB

struct Play: Codable, Identifiable {
    let id: String
    let driveID: String
    let gameID: Int
    let driveNumber: Int?
    let playNumber: Int?
    let offense: String
    let down: Int
    let distance: Int
    let yardLine: Int
    let playText: String?
    
    enum CodingKeys: String, CodingKey {
        case id, driveID, gameID, driveNumber, playNumber, offense, down, distance, yardLine, playText
    }
}

extension Play: FetchableRecord, PersistableRecord {
    enum Column: String, ColumnExpression {
        case id, driveID, gameID, driveNumber, playNumber, offense, down, distance, yardLine, playText
    }
}

extension Play {
    var playDescription: String {
        playText ?? ""
    }
}
