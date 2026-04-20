//
//  PlayRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum PlayRequest {
    case plays(year: Int, week: Int, seasonType: String, team: String, gameID: Int)
}

extension PlayRequest: APIRequest {
    var endpoint: PlayEndpoint {
        switch self {
        case .plays(let year, let week, let seasonType, let team, _):
            .plays(year: year, week: week, seasonType: seasonType, team: team)
        }
    }
    
    func handleResponse(_ response: [PlayAPIGET]) throws {
        switch self {
        case .plays(_, _, _, _, let gameID):
            try handlePlaysResponse(response, gameID: gameID)
        }
    }
    
    private func handlePlaysResponse(_ response: [PlayAPIGET], gameID: Int) throws {
        @Injected(\.playStore) var playStore
        
        for apiPlay in response where apiPlay.gameID == gameID {
            if let _ = try? playStore.getPlay(by: apiPlay.id) {
                continue
            }
            try? playStore.savePlay(apiPlay.toPlay())
        }
    }
}
