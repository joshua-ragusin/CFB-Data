//
//  WinProbabilityPlay.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation
import GRDB

struct WinProbabilityPlay: Codable {
    let id: UUID
    let gameID: Int
    let home: String
    let away: String
    let homeWinProbability: Double
    let playNumber: Int
    let yardLine: Int?
    let down: Int?
    let distance: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, gameID, home, away, homeWinProbability, playNumber, yardLine, down, distance
    }
}

extension WinProbabilityPlay: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, gameID, home, away, homeWinProbability, playNumber, yardLine, down, distance
    }
}

extension WinProbabilityPlay: Identifiable {}
