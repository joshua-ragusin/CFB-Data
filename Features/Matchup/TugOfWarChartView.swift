//
//  TugOfWarChartView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 11/2/25.
//

import SwiftUI
import UIKit

struct TugOfWarChartView: View {
    @StateObject private var model: TugOfWarChartViewModel
    
    init(model: TugOfWarChartViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            teamHeaderRow
            
            if model.totalGames > 0 {
                numericInfoRow
                tugOfWarChart
                
                Divider()
                
                currentWinStreakView
                
                Divider()
                
                navigationLinks
            } else {
                ContentUnavailableView(
                    "No Matchup History",
                    systemImage: "sportscourt",
                    description: Text("These teams have never played each other.")
                )
            }
        }
        .padding()
        .task {
            await model.fetchFullGameInfoBetweenTeams()
        }
    }
    
    // MARK: - Team Header

    private var teamHeaderRow: some View {
        HStack(alignment: .top, spacing: 0) {
            teamColumn(for: model.team1, alignment: .leading)
            Spacer()
            Text("vs")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.top, 22)
            Spacer()
            teamColumn(for: model.team2, alignment: .trailing)
        }
    }
    
    private func teamColumn(for team: Team, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 6) {
            teamLogo(for: team)
            Text(team.school)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(alignment == .leading ? .leading : .trailing)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private func teamLogo(for team: Team) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(team.color.opacity(0.15))
                .frame(width: 68, height: 68)
            
            if let uiImage = model.getTeamLogo(for: team.id) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56, height: 56)
            } else {
                Image(symbol: .exclamationMarkTriangleFill)
                    .foregroundStyle(.red)
            }
        }
    }
    
    // MARK: - Numeric Info
    
    private var numericInfoRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(model.firstTeamWins)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(model.team1.color)
                Text("Wins")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(model.firstTeamWinPercentage, format: .percent.precision(.fractionLength(1)))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("\(model.matchup.ties)")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Ties")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(model.secondTeamWins)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(model.team2.color)
                Text("Wins")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(model.seconedTeamWinPercentage, format: .percent.precision(.fractionLength(1)))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }
    
    // MARK: - Chart

    private var tugOfWarChart: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(model.team1.color)
                    .frame(width: geo.size.width * model.firstTeamWinPercentage)
                if model.tiePercentage > 0 {
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: geo.size.width * model.tiePercentage)
                }
                Rectangle()
                    .fill(model.team2.color)
            }
        }
        .frame(height: 28)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
    }
    
    // MARK: - Win Streak
    
    private var currentWinStreakView: some View {
        VStack(spacing: 6) {
            Text("Current Win Streak")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            if let streak = model.currentWinStreak {
                VStack(spacing: 2) {
                    Text(streak.team.school)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(streak.team.color)
                    HStack(spacing: 4) {
                        Text("\(streak.streak) in a row")
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text(streak.beginningDate, format: .dateTime.year())
                        Text("–")
                            .foregroundStyle(.secondary)
                        Text(streak.endDate, format: .dateTime.year())
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            } else {
                Text("No streak data available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Navigation Links
    
    private var navigationLinks: some View {
        VStack(spacing: 10) {
            NavigationLink {
                FullGamesView(games: model.fullGames)
            } label: {
                HStack {
                    Image(symbol: .listBulletinFill)
                    Text("Full Games List")
                    Spacer()
                    Image(symbol: .chevronRight)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            
            NavigationLink {
                HeadToHeadChartView(viewModel: HeadToHeadChartViewModel(
                    matchupID: model.matchup.id,
                    positiveTeam: model.team1,
                    negativeTeam: model.team2
                ))
            } label: {
                HStack {
                    Image(symbol: .americanFootball)
                    Text("Head to Head Results")
                    Spacer()
                    Image(symbol: .chevronRight)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
    }
}
