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
    var path: String {
        switch self {
        case .teamsFBS:
            "/teams/fbs"
        }
    }
    
    var parameters: [String : String]? {
        nil
    }
}
