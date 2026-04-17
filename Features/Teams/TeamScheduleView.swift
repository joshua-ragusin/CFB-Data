//
//  TeamScheduleView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/30/26.
//

import SwiftUI

struct TeamScheduleView: View {
    @StateObject var viewModel: TeamScheduleViewModel
    
    init(viewModel: TeamScheduleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var teamLogoSize: CGFloat {
        25.0
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                refreshView
            } else {
                scheduleView
            }
        }
        .navigationTitle("\(viewModel.teamName) \(viewModel.year) Season")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadGames()
        }
    }
    
    private var refreshView: some View {
        ProgressView()
    }
    
    private var scheduleView: some View {
        Grid {
            GridRow {
                Text("Result")
                Text("Date")
                Text("Opponent")
                Text("Score")
                Text("Notes")
            }
            
            ForEach(viewModel.games, id: \.id) { game in
                gridRow(for: game)
            }
        }
    }
    
    private func gridRow(for game: Game) -> some View {
        GridRow {
            resultColumn(for: game)
            dateColumn(for: game.date)
            opponentColumn(for: game)
            Text(game.scoreString)
            Text(game.notes ?? "")
        }
    }
    
    private func resultColumn(for game: Game) -> some View {
        switch viewModel.gameResult(game) {
        case .win:
            Text("W")
                .foregroundStyle(.green)
                .fontWeight(.semibold)
        case .loss:
            Text("L")
                .foregroundStyle(.red)
                .fontWeight(.semibold)
        case .tie:
            Text("T")
                .fontWeight(.semibold)
        }
    }
    
    private func opponentColumn(for game: Game) -> some View {
        HStack {
            if let opponentID = viewModel.getOpponentID(game) {
                HStack(spacing: 0) {
                    getOpponentImage(for: opponentID)
                    
                    if game.neutralSite {
                        Text("(N)")
                    }
                }
            } else {
                HStack(spacing: 0) {
                    genericOpponentImage(for: viewModel.getOpponentName(game).initialized())
                    
                    if game.neutralSite {
                        Text("(N)")
                    }
                }
            }
            
            Text(viewModel.getOpponentName(game))
        }
    }
    
    private func getOpponentImage(for opponentID: Int) -> some View {
        if let uiImage = viewModel.getTeamLogo(for: opponentID) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: teamLogoSize, height: teamLogoSize)
        } else {
            Image(symbol: .exclamationMarkTriangleFill)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: teamLogoSize, height: teamLogoSize)
        }
    }
    
    private func genericOpponentImage(for opponent: String) -> some View {
        ZStack {
            Circle()
                .foregroundStyle(.gray)
            Text(opponent)
        }
        .frame(width: teamLogoSize, height: teamLogoSize)
    }
    
    private func dateColumn(for gameDate: Date?) -> some View {
        if let gameDate {
            Text(gameDate, format: .dateTime.day().month(.abbreviated).year())
        } else {
            Text("")
        }
    }
}
