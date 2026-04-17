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
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.collegefootballdata.com"
    }
    
    var path: String {
        switch self {
        case .matchup(_, _):
            "/teams/matchup"
        }
    }
    
    var method: HTTPMethod {
        .get
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
    
    var headers: [String : String]? {
        [
            "Content-type" : "application/json",
            "Authorization" : "Bearer \(APIConfig.shared.cfbDataToken ?? "")"
        ]
    }
    
    
}
