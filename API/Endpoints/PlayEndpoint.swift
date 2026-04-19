//
//  PlayEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum PlayEndpoint {
    case plays(year: Int, week: Int, team: String)
}

extension PlayEndpoint: Endpoint {
    var path: String {
        switch self {
        case .plays(_, _, _):
            "/plays"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .plays(let year, let week, let team):
            [
                "year": String(year),
                "week": String(week),
                "team": team
            ]
        }
    }
}
