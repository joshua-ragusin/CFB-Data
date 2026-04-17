//
//  Matchup.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//
import Foundation
import GRDB

struct Matchup: Codable, Identifiable, Equatable {
    let id: UUID
    let team1: String
    let team2: String
    let team1Wins: Int
    let team2Wins: Int
    let ties: Int
}

extension Matchup: PersistableRecord, FetchableRecord {
    enum Columns: String, ColumnExpression {
        case id, team1, team2, team1Wins, team2Wins, ties
    }
}
