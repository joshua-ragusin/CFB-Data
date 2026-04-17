//
//  MatchupAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//
import Foundation

struct MatchupAPIGET: Codable {
    let id = UUID()
    let team1: String
    let team2: String
    let team1Wins: Int
    let team2Wins: Int
    let ties: Int
    let games: [GameMatchupAPIGET]
    
    enum CodingKeys: String, CodingKey {
        case team1, team2, team1Wins, team2Wins, ties, games
    }
    
    func toMatchup() -> Matchup {
        var decodedGames = [MatchupGame]()

        for game in games {
            decodedGames.append(game.toGame())
        }
        
        return Matchup(id: id,
                       team1: team1,
                       team2: team2,
                       team1Wins: team1Wins,
                       team2Wins: team2Wins,
                       ties: ties)
    }
}
