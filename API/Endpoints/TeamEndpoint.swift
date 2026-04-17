//
//  TeamAPI.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import Foundation

enum TeamEndpoint {
    case teamsFBS
}

extension TeamEndpoint: Endpoint {
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.collegefootballdata.com"
    }
    
    var path: String {
        switch self {
        case .teamsFBS:
            return "/teams/fbs"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String : String]? {
        nil
    }
    
    var headers: [String : String]? {
        [
            "Content-type" : "application/json",
            "Authorization" : "Bearer \(APIConfig.shared.cfbDataToken ?? "")"
        ]
    }
    
}
