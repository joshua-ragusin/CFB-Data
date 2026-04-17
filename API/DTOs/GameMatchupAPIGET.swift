//
//  GameMatchupAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//
import Foundation
struct GameMatchupAPIGET: Codable {
    let id = UUID()
    let season: Int
    let week: Int
    let dateString: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    
    enum CodingKeys: String, CodingKey {
        case season, week, homeTeam, awayTeam, homeScore, awayScore
        case dateString = "date"
    }
    
    func toGame() -> MatchupGame {
        MatchupGame(id: id,
             season: season,
             week: week,
             dateString: dateString,
             homeTeam: homeTeam,
             awayTeam: awayTeam,
             homeScore: homeScore,
             awayScore: awayScore)
    }
}
