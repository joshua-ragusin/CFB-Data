//
//  MatchupMainViewViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/23/25.
//

import SwiftUI

class MatchupMainViewViewModel: ObservableObject {
    @Published var matchup: Matchup?
    @Published var selectedTeam1: Team?
    @Published var selectedTeam2: Team?
    
    @Injected(\.networkClient) private var networkClient
    @Injected(\.gameStore) private var gameStore
    @Injected(\.matchupStore) private var matchupStore
    
    func fetchMatchup() async {
        guard let team1 = selectedTeam1,
              let team2 = selectedTeam2 else {
            // TODO: Show Error for invalid selection
            print("Invalid selection: At least 1 team must be selected")
            return
        }
        
        guard team1 != team2 else {
            // TODO: Show error for same team selection
            print("Invalid selection: Cannot select the same team twice")
            return
        }
        
        if let dbResult = try? matchupStore.getMatchup(for: team1.school, and: team2.school) {
            await MainActor.run {
                matchup = dbResult
            }
        } else {
            do {
                print("API CALL: Matchup for \(team1.school) vs \(team2.school)")
                try await handleMatchupRequest(for: team1, and: team2)
                
                await MainActor.run {
                    matchup = try? matchupStore.getMatchup(for: team1.school, and: team2.school)
                }
            } catch NetworkError.decodingError {
                print("No matchup history")
                let emptyMatchup = Matchup(id: UUID(), team1: team1.school, team2: team2.school, team1Wins: 0, team2Wins: 0, ties: 0)
                try? saveFetchedData(matchup: emptyMatchup)
                await MainActor.run {
                    matchup = emptyMatchup
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func handleMatchupRequest(for team1: Team, and team2: Team) async throws {
        try await networkClient.send(MatchupRequest.matchups(team1: team1.school, team2: team2.school))
    }
    
    private func saveFetchedData(matchup: Matchup) throws {
        try matchupStore.saveMatchup(matchup)
    }
}
