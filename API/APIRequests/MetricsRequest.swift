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
        case .winProbabilityPlays(let gameID):
            try handleWinProbabilityPlaysRequest(response)
        }
    }
    
    private func handleWinProbabilityPlaysRequest(_ response: [WinProbabilityPlayAPIGET]) throws {
        print(response)
    }
}
