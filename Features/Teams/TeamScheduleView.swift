//
//  TeamScheduleView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/30/26.
//

import SwiftUI
import UIKit

struct TeamScheduleView: View {
    @StateObject var viewModel: TeamScheduleViewModel
    
    init(viewModel: TeamScheduleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        // 6. Show loading/empty/content states at the top level so
        //    ProgressView and ContentUnavailableView can center properly.
        Group {
            if viewModel.isLoading {
                ProgressView("Loading schedule...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.games.isEmpty {
                // 7. Empty state
                ContentUnavailableView(
                    "No Games Found",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("No games are available for the \(viewModel.year) season.")
                )
            } else {
                // 1. List gives built-in scrolling and row separators
                gameList
            }
        }
        .navigationTitle("\(viewModel.teamName) \(viewModel.year)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadGames()
        }
    }
    
    // MARK: - Game List
    
    private var gameList: some View {
        List(viewModel.games) { game in
            gameRow(for: game)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
    }
    
    // MARK: - Game Row
    
    // 2. Redesigned row: result badge | opponent info | score + date
    private func gameRow(for game: Game) -> some View {
        HStack(spacing: 12) {
            resultBadge(for: game)
            opponentInfo(for: game)
            Spacer()
            scoreAndDate(for: game)
        }
    }
    
    private func resultBadge(for game: Game) -> some View {
        let (letter, color): (String, Color) = {
            switch viewModel.gameResult(game) {
            case .win:  return ("W", .green)
            case .loss: return ("L", .red)
            case .tie:  return ("T", .gray)
            }
        }()
        
        return Text(letter)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(color)
            .frame(width: 20)
    }
    
    // 3. Notes appear inline below opponent name, not as a separate column
    private func opponentInfo(for game: Game) -> some View {
        HStack(spacing: 8) {
            opponentLogo(for: game)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(viewModel.getOpponentName(game))
                        .font(.subheadline)
                    // 4. Neutral site as a small pill badge
                    if game.neutralSite {
                        Text("N")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(.secondary.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                if let notes = game.notes {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
    
    // 5. Fixed content mode: .fit instead of .fill for logos
    @ViewBuilder
    private func opponentLogo(for game: Game) -> some View {
        let size: CGFloat = 30
        if let opponentID = viewModel.getOpponentID(game),
           let uiImage = viewModel.getTeamLogo(for: opponentID) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        } else {
            ZStack {
                Circle()
                    .foregroundStyle(.secondary.opacity(0.15))
                Text(viewModel.getOpponentName(game).initialized())
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(width: size, height: size)
        }
    }
    
    // Score stacked above date, right-aligned
    private func scoreAndDate(for game: Game) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(game.scoreString)
                .font(.subheadline)
                .fontWeight(.semibold)
                .monospacedDigit()
            if let date = game.date {
                Text(date, format: .dateTime.month(.abbreviated).day())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
