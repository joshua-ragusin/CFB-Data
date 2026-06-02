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
    @Injected(\.playStore) private var playStore
    @Injected(\.networkClient) private var networkClient
    
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
                drives = groupPlaysByDrive(drives: cached)
            }
            
            return
        }
        
        do {
            print("API CALL: GET DRIVES FOR GAME: \(game.id)")
            async let homeDrives = networkClient.send(DriveRequest.drives(
                year: game.season, week: game.week, seasonType: game.seasonType,
                team: game.homeTeam, gameID: game.id
            ))
            async let awayDrives = networkClient.send(DriveRequest.drives(
                year: game.season, week: game.week, seasonType: game.seasonType,
                team: game.awayTeam, gameID: game.id
            ))
            _ = try await (homeDrives, awayDrives)
            
            await MainActor.run {
                let dbDrives = (try? driveStore.getDrives(for: game.id)) ?? []
                drives = groupPlaysByDrive(drives: dbDrives)
            }
        } catch {
            print(error)
        }
        
        await MainActor.run { isLoading = false }
    }
    
    func fetchPlays() async {
        await MainActor.run { isLoading = true }
        
        let cached = (try? playStore.getPlays(for: game.id)) ?? []
        if !cached.isEmpty {
            await MainActor.run { isLoading = false }
            return
        }
        
        do {
            print("API CALL: GET PLAYS FOR GAME: \(game.id)")
            async let homePlays = networkClient.send(PlayRequest.plays(
                year: game.season, week: game.week, seasonType: game.seasonType,
                team: game.homeTeam, gameID: game.id
            ))
            async let awayPlays = networkClient.send(PlayRequest.plays(
                year: game.season, week: game.week, seasonType: game.seasonType,
                team: game.awayTeam, gameID: game.id
            ))
            _ = try await (homePlays, awayPlays)
        } catch {
            print(error)
        }
        
        await MainActor.run { isLoading = false }
    }
    
    private func groupPlaysByDrive(drives: [Drive]) -> [Drive] {
        let driveIDs = drives.map(\.id)
        let allPlays = (try? playStore.getPlays(forDrives: driveIDs)) ?? []
        let playsByDrive = Dictionary(grouping: allPlays, by: \.driveID)

        return drives.map { drive in
            var updated = drive
            updated.groupedPlays = playsByDrive[drive.id] ?? []
            return updated
        }
    }
}
