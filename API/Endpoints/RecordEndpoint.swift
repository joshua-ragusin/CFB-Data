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
    var scheme: String { "https" }
    
    var host: String { "api.collegefootballdata.com" }
    
    var path: String {
        switch self {
        case .records(_):
            "/records"
        }
    }
    
    var method: HTTPMethod { . get }
    
    var parameters: [String : String]? {
        switch self {
        case .records(let team):
            ["team": team]
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-type" : "application/json",
            "Authorization" : "Bearer \(APIConfig.shared.cfbDataToken ?? "")"
        ]
    }
    
    
}
