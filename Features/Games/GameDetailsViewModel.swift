//
//  GameDetailsViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation
import SwiftUI


class GameDetailsViewModel: ObservableObject {
    @Published var winProbabilityPlays: [WinProbabilityPlay]
    @Published var isLoading = false
    
    let game: Game
    
    @Injected(\.metricsStore) private var metricsStore
    @Injected(\.networkClient) private var networkClient
    
    init(game: Game) {
        self.game = game
        
        let store = InjectedValues[\.metricsStore]
        winProbabilityPlays = (try? store.getWinProbabilityPlays(for: game.id)) ?? []
    }
    
    func fetchWinProbabilityPlays() async {
        await MainActor.run {
            isLoading = true
        }

        if winProbabilityPlays.isEmpty {
            do {
                print("API CALL: GET WP PLAYS FOR: \(game.id)")
                try await networkClient.send(MetricsRequest.winProbabilityPlays(gameID: game.id))
                
                await MainActor.run {
                    winProbabilityPlays = (try? metricsStore.getWinProbabilityPlays(for: game.id)) ?? []
                }
            } catch {
                print(error)
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
}
