//
//  MatchupRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

enum MatchupRequest {
    case matchups(team1: String, team2: String)
}

extension MatchupRequest: APIRequest {
    typealias Response = MatchupAPIGET

    var endpoint: MatchupEndpoint {
        switch self {
            case .matchups(team1: let team1, team2: let team2):
                .matchup(team1: team1, team2: team2)
        }
    }
    
    func handleResponse(_ response: MatchupAPIGET) throws {
        switch self {
        case .matchups(_, _):
            try handleMatchupsResponse(response)
        }
    }
    
    private func handleMatchupsResponse(_ response: MatchupAPIGET) throws {
        @Injected(\.gameStore) var gameStore
        @Injected(\.matchupStore) var matchupStore
        
        try matchupStore.saveMatchup(response.toMatchup())
        
        for apiGame in response.games {
            try gameStore.saveMatchupGame(apiGame.toGame())
            try gameStore.saveGameMatchupLink(GameMatchupLink(gameID: apiGame.id, matchupID: response.id))
        }
    }
}
