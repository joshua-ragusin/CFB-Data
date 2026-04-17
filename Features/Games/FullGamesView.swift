//
//  FullGamesView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/16/26.
//

import SwiftUI

struct FullGamesView: View {
    
    let games: [Game]
    
    @Injected(\.networkClient) private var networkClient
    
    var body: some View {
        List(games) { game in
            gameView(for: game)
        }
        .task {
            if let game = games.last {
                await fetchWPMetrics(for: game)
            }
        }
    }
    
    private func gameView(for game: Game) -> some View {
        VStack(alignment: .leading) {
            if let date = game.date {
                Text(date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text(game.homeTeam)
                Spacer()
                Text(game.scoreString)
                Spacer()
                Text(game.awayTeam)
            }
        }
    }
    
    private func fetchWPMetrics(for game: Game) async {
        do {
            try await networkClient.send(MetricsRequest.winProbabilityPlays(gameID: game.id))
        } catch {
            print(error)
        }
    }
}
