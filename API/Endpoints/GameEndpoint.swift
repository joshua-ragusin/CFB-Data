//
//  GameEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

enum GameEndpoint {
    case games(team: String, year: Int)
    case gamesWithTeams(year: Int, homeTeam: String, awayTeam: String)
}

extension GameEndpoint: Endpoint {
    var path: String {
        switch self {
        case .games(_, _),
             .gamesWithTeams(_, _, _):
            "/games"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .games(let team, let year):
            [
                "year": String(year),
                "team": team
            ]
        case .gamesWithTeams(let year, let homeTeam, let awayTeam):
            [
                "year": String(year),
                "home": homeTeam,
                "away": awayTeam
            ]
        }
    }
}
