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
    
    typealias Identifier = FullGameViewIdentifier
    
    var body: some View {
        List(games) { game in
            gameView(for: game)
        }
        .accessibilityID(Identifier.gamesList)
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
                detailsNavigationLink(for: game)
            }
        }
    }
    
    private func detailsNavigationLink(for game: Game) -> some View {
        NavigationLink {
            GameDetailsView(
                viewModel: GameDetailsViewModel(game: game, homeID: game.homeID, awayID: game.awayID)
            )
        } label: {
            Image(symbol: .chevronRight)
        }

    }
}
