//
//  MatchupEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

enum MatchupEndpoint {
    case matchup(team1: String, team2: String)
}

extension MatchupEndpoint: Endpoint {
    var path: String {
        switch self {
        case .matchup(_, _):
            "/teams/matchup"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .matchup(let team1, let team2):
            [
                "team1": team1,
                "team2": team2
            ]
        }
    }
}
