//
//  WinProbabilityPlayAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/16/26.
//

import Foundation

struct WinProbabilityPlayAPIGET: Codable {
    let id = UUID()
    let gameID: Int
    let home: String
    let away: String
    let homeWinProbability: Double
    let playNumber: Int
    let yardLine: Int?
    let down: Int?
    let distance: Int?
    
    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case home, away, homeWinProbability, playNumber, yardLine, down, distance
    }
}
