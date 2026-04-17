//
//  MetricsEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/16/26.
//

enum MetricsEndpoint {
    case winProbabilityPlays(gameID: Int)
}

extension MetricsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .winProbabilityPlays(let gameID):
            "/metrics/wp"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .winProbabilityPlays(let gameID):
            ["gameId" : gameID.description]
        }
    }
}
