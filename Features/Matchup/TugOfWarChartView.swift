//
//  TugOfWarChartView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 11/2/25.
//

import SwiftUI

struct TugOfWarChartView: View {
    
    @StateObject private var model: TugOfWarChartViewModel
    
    var tugOfWarChartWidth: CGFloat = 400
    var teamLogoSize: CGFloat = 75
    
    init(model: TugOfWarChartViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        VStack {
            HStack {
                teamLogo(for: model.team1)
                chartInfo
                teamLogo(for: model.team2)
            }
            
            currentWinStreakView
            fullListOfGamesButton
            headToHeadResultsLink
        }
        .task {
            await model.fetchFullGameInfoBetweenTeams()
        }
    }
    
    // MARK: - Team Logo
    
    @ViewBuilder
    private func teamLogo(for team: Team) -> some View {
        if let uiImage = model.getTeamLogo(for: team.id) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: teamLogoSize, height: teamLogoSize)
        } else {
            Image(symbol: .exclamationMarkTriangleFill)
                .frame(width: teamLogoSize, height: teamLogoSize)
        }
    }
        
    // MARK: - Chart Numeric Info
    
    private var chartInfo: some View {
        VStack(alignment: .center) {
            chartNumericInfo
            tugOfWarChart
        }
    }
    
    private var chartNumericInfo: some View {
        HStack(alignment: .center) {
            team1NumericInfo
            Spacer()
            tieNumericInfo
            Spacer()
            team2NumericInfo
        }
    }
    
    private var team1NumericInfo: some View {
        HStack {
            Text(String(model.firstTeamWins))
                .font(.title3)
            
            VStack {
                Text("Wins")
                Text("(\(model.firstTeamWinPercentage))")
            }
            .font(.caption)
        }
    }
    
    private var team2NumericInfo: some View {
        HStack {
            Text(String(model.secondTeamWins))
                .font(.title3)
            
            VStack {
                Text("Wins")
                Text("(\(model.seconedTeamWinPercentage))")
            }
            .font(.caption)
        }
    }
    
    private var tieNumericInfo: some View {
        HStack {
            Text(String(model.matchup.ties))
            Text("Ties")
        }
    }
    
    // MARK: - Tug of War Chart
    
    private var tugOfWarChart: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(model.team1.color)
                .frame(width: tugOfWarChartWidth * model.firstTeamWinPercentage)
            Rectangle()
                .fill(Color.black)
                .frame(width: tugOfWarChartWidth * model.tiePercentage)
            Rectangle()
                .fill(model.team2.color)
                .frame(width: tugOfWarChartWidth * model.seconedTeamWinPercentage)
        }
        .frame(height: 50)
    }
    
    // MARK: - Win Streak
    private var currentWinStreakView: some View {
        let currentWinStreak = model.currentWinStreak
        return VStack(alignment: .center) {
                Text("Current Win Streak")
            HStack {
                if let currentWinStreak {
                    Text("\(currentWinStreak.streak) \(currentWinStreak.team.school)")
                    Text(currentWinStreak.beginningDate, format: .dateTime.year())
                    Text(" - ")
                    Text(currentWinStreak.endDate, format: .dateTime.year())
                }
            }
            .fontWeight(.semibold)
            .foregroundStyle(currentWinStreak?.team.color ?? .black)
        }
    }
    
    // MARK: - Head-to-Head Results
    private var headToHeadResultsLink: some View {
        NavigationLink(destination: HeadToHeadChartView(viewModel: HeadToHeadChartViewModel(matchupID: model.matchup.id, positiveTeam: model.team1, negativeTeam: model.team2))) {
            HStack {
                Text("Head to Head Results")
                Image(symbol: .chevronRight)
            }
        }
    }

    // MARK: - Full list of games
    
    private var fullListOfGamesButton: some View {
        NavigationLink(destination: EmptyView()) {
            HStack {
                Text("Full Games List Page")
                Image(symbol: .chevronRight)
            }
        }
    }
}
