//
//  MatchupMainView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI
import UIKit

struct MatchupMainView: View {
    @StateObject private var model = MatchupMainViewViewModel()
    
    @Injected(\.teamStore) private var teamStore
    
    @State private var fetchMatchup = false
    @State private var tugOWarID = UUID()
    
    typealias Identifier = MatchupMainViewIdentifier
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        teamSelectCard(
                            label: "Select Team 1",
                            team: model.selectedTeam1,
                            binding: $model.selectedTeam1
                        )
                        .accessibilityID(Identifier.team1Button)

                        teamSelectCard(
                            label: "Select Team 2",
                            team: model.selectedTeam2,
                            binding: $model.selectedTeam2
                        )
                        .accessibilityID(Identifier.team2Button)
                    }
                    .padding(.horizontal)
                    
                    compareButton
                    
                    // Matchup results
                    if let matchup = model.matchup {
                        Divider()
                            .padding(.horizontal)
                        
                        TugOfWarChartView(
                            model: TugOfWarChartViewModel(
                                matchup: matchup,
                                team1: model.selectedTeam1!,
                                team2: model.selectedTeam2!
                            )
                        )
                        .id(tugOWarID)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Matchups")
            .navigationBarTitleDisplayMode(.large)
            .accessibilityID(Identifier.matchupView)
        }
    }
    
    // MARK: - Compare Button
    private var compareButton: some View {
        Button {
            fetchMatchup = true
            Task {
                await model.fetchMatchup()
                fetchMatchup = false
            }
            tugOWarID = UUID()
        } label: {
            Group {
                if fetchMatchup {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Compare")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .buttonStyle(.borderedProminent)
        .disabled(
            fetchMatchup ||
            model.selectedTeam1 == nil ||
            model.selectedTeam2 == nil ||
            model.selectedTeam1 == model.selectedTeam2
        )
        .padding(.horizontal)
        .accessibilityID(Identifier.compareButton)
    }
    
    // MARK: - Team Select Card
    
    private func teamSelectCard(label: String, team: Team?, binding: Binding<Team?>) -> some View {
        NavigationLink {
            TeamDropdownView(team: binding)
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill((team?.color ?? Color.secondary).opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    if let team,
                       let data = try? teamStore.getTeamLogo(teamID: team.id)?.logoData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 52, height: 52)
                    } else {
                        Image(symbol: .plusCircle)
                            .font(.title2)
                            .foregroundStyle(team == nil ? Color.secondary : Color.red)
                    }
                }
                
                Text(team?.school ?? label)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(team == nil ? .secondary : .primary)
                
                if let team {
                    Text(team.conference)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background((team?.color ?? Color.secondary).opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .topTrailing) {
                if team != nil {
                    Button {
                        binding.wrappedValue = nil
                        model.matchup = nil
                    } label: {
                        Image(symbol: .xMarkCircleFill)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    .allowsHitTesting(true)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
