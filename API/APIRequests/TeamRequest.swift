//
//  TeamRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import Foundation

enum TeamRequest {
    case teamsFBS
}

extension TeamRequest: APIRequest {
    typealias Response = [TeamAPIGET]
    
    var endpoint: TeamEndpoint {
        switch self {
        case .teamsFBS:
                .teamsFBS
        }
    }
    
    func handleResponse(_ response: [TeamAPIGET]) throws {
        switch self {
        case .teamsFBS:
            try handleTeamFBSRequest(response)
        }
    }
    
    private func handleTeamFBSRequest(_ response: [TeamAPIGET]) throws {
        @Injected(\.teamStore) var teamStore
        
        for apiTeam in response {
            try teamStore.saveTeam(apiTeam.toTeam())
        }
    }
}
