//
//  PlayRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum PlayRequest {
    case plays(year: Int, week: Int, team: String)
}

extension PlayRequest: APIRequest {
    var endpoint: PlayEndpoint {
        switch self {
        case .plays(let year, let week, let team):
                .plays(year: year, week: week, team: team)
        }
    }
    
    func handleResponse(_ response: [PlayAPIGET]) throws {
        switch self {
        case .plays(_, _, _):
            try handleTeamsResponse(response)
        }
    }
    
    private func handleTeamsResponse(_ response: [PlayAPIGET]) throws {
        @Injected(\.playStore) var playStore
        
        for apiPlay in response {
            if let _ = try? playStore.getPlay(by: apiPlay.id) {
                continue
            } else {
                try? playStore.savePlay(apiPlay.toPlay())
            }
        }
    }
}
