//
//  TeamScheduleViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/30/26.
//

import Foundation
import SwiftUI

class TeamScheduleViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading: Bool = false
    
    @Injected(\.gameStore) private var gameStore
    @Injected(\.teamStore) private var teamStore
    @Injected(\.networkClient) private var networkClient
    
    let teamName: String
    let year: Int
    let teamID: Int
    let totalGames: Int
    
    init(record: Record) {
        self.teamName = record.team
        self.year = record.year
        self.teamID = record.teamID
        
        let store = InjectedValues[\.recordStore]
        if let totalRecordCategory = try? store.getRecordCategory(with: record.totalRecordID) {
            self.totalGames = totalRecordCategory.wins + totalRecordCategory.losses + totalRecordCategory.ties
        } else {
            self.totalGames = -1
        }
    }
    
    func loadGames() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let games = try gameStore.getGames(for: teamID, in: year)
            
            if totalGames < 0 || games.count < totalGames {
                try await fetchGames()
                let savedGames = try gameStore.getGames(for: teamID, in: year)
                
                await MainActor.run {
                    self.games = savedGames
                }
            } else {
                await MainActor.run {
                    self.games = games
                }
            }
        } catch {
            print("TeamScheduleViewModel ERROR: \(error)")
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    func gameResult(_ game: Game) -> GameResult {
        if teamID == game.homeID {
            return game.homePoints > game.awayPoints ? .win : game.awayPoints > game.homePoints ? .loss : .tie
        } else {
            return game.homePoints > game.awayPoints ? .loss : game.awayPoints > game.homePoints ? .win : .tie
        }
    }
    
    func getOpponentName(_ game: Game) -> String {
        if teamID == game.homeID {
            return game.awayTeam
        } else {
            return game.homeTeam
        }
    }
    
    func getOpponentID(_ game: Game) -> Int? {
        if teamID == game.homeID {
            return game.awayID
        } else {
            return game.homeID
        }
    }
    
    func getTeamLogo(for teamID: Int) -> UIImage? {
        guard let teamLogoData = try? teamStore.getTeamLogo(teamID: teamID),
              let teamLogo = UIImage(data: teamLogoData.logoData) else {
            return nil
        }
        
        return teamLogo
    }
    
    // MARK: - Private helpers
    
    private func fetchGames() async throws {
        try await networkClient.send(GameRequest.gamesTeams(team: teamName, year: year))
    }
}

enum GameResult {
    case win
    case loss
    case tie
}
