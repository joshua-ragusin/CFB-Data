//
//  GameDetailsViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation
import SwiftUI


class GameDetailsViewModel: ObservableObject {
    @Published var winProbabilityPlays: [WinProbabilityPlay] = []
    @Published var isLoading = false
    
    let game: Game
    
    @Injected(\.metricsStore) private var metricsStore
    @Injected(\.networkClient) private var networkClient
    
    init(game: Game) {
        self.game = game
    }
    
    func fetchWinProbabilityPlays() async {
        await MainActor.run { isLoading = true }

        let cached = (try? metricsStore.getWinProbabilityPlays(for: game.id)) ?? []
        if !cached.isEmpty {
            await MainActor.run {
                winProbabilityPlays = cached
                isLoading = false
            }
            return
        }

        do {
            print("API CALL: GET WP PLAYS FOR: \(game.id)")
            try await networkClient.send(MetricsRequest.winProbabilityPlays(gameID: game.id))
            
            await MainActor.run {
                winProbabilityPlays = (try? metricsStore.getWinProbabilityPlays(for: game.id)) ?? []
            }
        } catch {
            print(error)
        }
        
        await MainActor.run { isLoading = false }
    }
}
