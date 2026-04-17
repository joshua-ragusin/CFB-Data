//
//  RecordEndpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

enum RecordEndpoint {
    case records(team: String)
}

extension RecordEndpoint: Endpoint {
    var path: String {
        switch self {
        case .records(_):
            "/records"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .records(let team):
            ["team": team]
        }
    }
}
