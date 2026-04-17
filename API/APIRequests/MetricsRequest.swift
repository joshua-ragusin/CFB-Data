//
//  MetricsRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/16/26.
//

enum MetricsRequest {
    case winProbabilityPlays(gameID: Int)
}

extension MetricsRequest: APIRequest {
    var endpoint: MetricsEndpoint {
        switch self {
        case .winProbabilityPlays(let gameID):
                .winProbabilityPlays(gameID: gameID)
        }
    }
    
    func handleResponse(_ response: [WinProbabilityPlayAPIGET]) throws {
        switch self {
        case .winProbabilityPlays(_):
            try handleWinProbabilityPlaysRequest(response)
        }
    }
    
    private func handleWinProbabilityPlaysRequest(_ response: [WinProbabilityPlayAPIGET]) throws {
        @Injected(\.metricsStore) var metricsStore
        
        for apiWPPlay in response {
            // Query DB to see if WPPlay exists. Save it if not.
            if let dbResult = try? metricsStore.getWinProbabilityPlay(for: apiWPPlay.gameID, playNumber: apiWPPlay.playNumber) {
                continue
            } else {
                print("Saving WPPlay for gameID: \(apiWPPlay.gameID) playNumber: \(apiWPPlay.playNumber)")
                try! metricsStore.saveWinProbabilityPlay(apiWPPlay.toWinProbabilityPlay())
            }
        }
    }
}
