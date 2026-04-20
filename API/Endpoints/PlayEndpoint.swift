//
//  PlayEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum PlayEndpoint {
    case plays(year: Int, week: Int, seasonType: String, team: String)
}

extension PlayEndpoint: Endpoint {
    var path: String {
        switch self {
        case .plays:
            "/plays"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .plays(let year, let week, let seasonType, let team):
            [
                "year": String(year),
                "week": String(week),
                "seasonType": seasonType,
                "team": team
            ]
        }
    }
}
