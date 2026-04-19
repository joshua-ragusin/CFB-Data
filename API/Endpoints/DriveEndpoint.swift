//
//  DriveEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum DriveEndpoint {
    case drives(year: Int, week: Int, team: String)
}

extension DriveEndpoint: Endpoint {
    var path: String {
        switch self {
        case .drives(_, _, _):
            "/drives"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .drives(let year, let week, let team):
            [
                "year": String(year),
                "week": String(week),
                "team": team
            ]
        }
    }
}
