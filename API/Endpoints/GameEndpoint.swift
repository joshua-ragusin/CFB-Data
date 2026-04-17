//
//  GameEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

enum GameEndpoint {
    case games(team: String, year: Int)
}

extension GameEndpoint: Endpoint {
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.collegefootballdata.com"
    }
    
    var path: String {
        switch self {
        case .games(_, _):
            "/games"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String : String]? {
        switch self {
        case .games(let team, let year):
            [
                "year": String(year),
                "team": team
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
