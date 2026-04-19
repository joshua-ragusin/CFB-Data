//
//  GameDetailsViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import Foundation
import SwiftUI


class GameDetailsViewModel: ObservableObject {
    @Published var winProbabilityPlays: [WinProbabilityPlay] = []
    @Published var drives: [Drive] = []
    @Published var isLoading = false
    
    let game: Game
    let homeID: Int
    let awayID: Int
    
    @Injected(\.metricsStore) private var metricsStore
    @Injected(\.driveStore) private var driveStore
    @Injected(\.teamStore) private var teamStore
    @Injected(\.networkClient) private var networkClient
    
    var homeTeamName: String {
        (try? teamStore.getTeam(by: homeID)?.school) ?? ""
    }
    
    init(game: Game, homeID: Int?, awayID: Int?) {
        self.game = game
        self.homeID = homeID ?? 0
        self.awayID = awayID ?? 0
    }
    
    func fetchWinProbabilityPlays() async {
        await MainActor.run { isLoading = true }

        let cached = (try? metricsStore.getWinProbabilityPlays(for: game.id)) ?? []
        if !cached.isEmpty {
            await MainActor.run {
                winProbabilityPlays = cached
                isLoading = false
            }
            return
        }

        do {
            print("API CALL: GET WP PLAYS FOR: \(game.id)")
            try await networkClient.send(MetricsRequest.winProbabilityPlays(gameID: game.id))
            
            await MainActor.run {
                winProbabilityPlays = (try? metricsStore.getWinProbabilityPlays(for: game.id)) ?? []
            }
        } catch {
            print(error)
        }
        
        await MainActor.run { isLoading = false }
    }
    
    func fetchDrives() async {
        await MainActor.run { isLoading = true }
        
        let cached = (try? driveStore.getDrives(for: game.id)) ?? []
        if !cached.isEmpty {
            await MainActor.run {
                isLoading = false
                drives = groupPlaysByDrive(plays: winProbabilityPlays, drives: cached)
            }
            
            return
        }
        
        do {
            print("API CALL: GET DRIVES FOR: YEAR: \(game.season) WEEK: \(game.week), TEAM: \(homeTeamName)")
            try await networkClient.send(DriveRequest.drives(year: game.season, week: game.week, team: homeTeamName))
            
            await MainActor.run {
                let dbDrives = (try? driveStore.getDrives(for: game.id)) ?? []
                drives = groupPlaysByDrive(plays: winProbabilityPlays, drives: dbDrives)
            }
        } catch {
            print(error)
        }
        
        await MainActor.run { isLoading = false }
    }
    
    private func groupPlaysByDrive(plays: [WinProbabilityPlay], drives: [Drive]) -> [Drive] {
        var updatedDrives = drives
        var playIndex = 0
        
        for i in 0..<updatedDrives.count {
            var playCount = updatedDrives[i].plays
            
            if updatedDrives[i].driveResult == "PUNT" {
                playCount += 1
            }
            
            let endIndex = min(playIndex + playCount, plays.count)
            updatedDrives[i].groupedPlays = Array(plays[playIndex..<endIndex])
            playIndex = endIndex
        }
        
        return updatedDrives
    }
}
