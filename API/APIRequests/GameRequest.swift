//
//  GameRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

enum GameRequest {
    case gamesTeams(team: String, year: Int)
}

extension GameRequest: APIRequest {
    var endpoint: GameEndpoint {
        switch self {
        case .gamesTeams(let team, let year):
            .games(team: team, year: year)
        }
    }
    
    func handleResponse(_ response: [GameAPIGET]) throws {
        switch self {
        case .gamesTeams(_, _):
            try handleGameTeamsResponse(response)
        }
    }
    
    private func handleGameTeamsResponse(_ response: [GameAPIGET]) throws {
        @Injected(\.gameStore) var gameStore
        
        for apiGame in response {
            if let _ = try gameStore.getGame(by: apiGame.id) {
                continue
            } else {
                try handleSaveAPIGame(apiGame)
            }
        }
    }
    
    private func handleSaveAPIGame(_ apiGame: GameAPIGET) throws {
        @Injected(\.gameStore) var gameStore
        @Injected(\.teamStore) var teamStore
        
        let homeID: Int?
        let awayID: Int?

        if let apiHomeID = apiGame.homeID,
           let _ = try teamStore.getTeam(by: apiHomeID) {
            homeID = apiHomeID
        } else {
            homeID = nil
        }
        
        if let apiAwayID = apiGame.awayID,
           let _ = try teamStore.getTeam(by: apiAwayID) {
            awayID = apiAwayID
        } else {
            awayID = nil
        }
        
        try gameStore.saveGame(GameAPIGET(apiGame: apiGame, homeID: homeID, awayID: awayID).toGame())
    }
}
