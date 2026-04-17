//
//  MastchupMainView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI

struct MatchupMainView: View {
    @StateObject private var model = MatchupMainViewViewModel()
    
    @State private var fetchMatchup = false
    @State private var tugOWarID = UUID()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    team1SelectButton
                    team2SelectButton
                }
                
                compareButton
                
                if let matchup = model.matchup {
                    TugOfWarChartView(model: TugOfWarChartViewModel(matchup: matchup, team1: model.selectedTeam1!, team2: model.selectedTeam2!))
                        .id(tugOWarID)
                }
                
                Spacer()
                Spacer()
            }
            .navigationTitle("Matchups")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var team1SelectButton: some View {
        NavigationLink(model.selectedTeam1?.school ?? "Select a team") {
            TeamDropdownView(team: $model.selectedTeam1)
        }
    }
    
    private var team2SelectButton: some View {
        NavigationLink(model.selectedTeam2?.school ?? "Select a team") {
            TeamDropdownView(team: $model.selectedTeam2)
        }
    }
    
    private var compareButton: some View {
        Button {
            fetchMatchup = true
            
            Task {
                await model.fetchMatchup()
                fetchMatchup = false
            }
            
            tugOWarID = UUID()
        } label : {
            Text("Compare")
        }
        .disabled(fetchMatchup)
    }
    
    private func matchupSumaryView(for matchup: Matchup) -> some View {
        Text("RESULTS: \(matchup.team1) is \(matchup.team1Wins) - \(matchup.team2Wins) - \(matchup.ties) against \(matchup.team2)")
    }
}
