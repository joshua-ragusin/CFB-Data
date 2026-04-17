//
//  TugOfWarChartViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 11/2/25.
//

import SwiftUI

class TugOfWarChartViewModel: ObservableObject {
    let matchup: Matchup
    let team1: Team
    let team2: Team
    
    // MARK: - Matchup Numeric Info
    // Private computed vars needed to determine which team appears first in the matchup view

    private var firstTeam: Team {
        team1.school == matchup.team1 ? team1 : team2
    }

    private var secondTeam: Team {
        team1.school == matchup.team1 ? team2 : team1
    }
    
    private var firstTeamName: String {
        team1.school
    }
    
    private var secondTeamName: String {
        team2.school
    }
    
    var totalGames: Int {
        matchup.team1Wins + matchup.team2Wins + matchup.ties
    }
    
    var firstTeamWins: Int {
        team1.school == matchup.team1 ? matchup.team1Wins : matchup.team2Wins
    }
    
    var secondTeamWins: Int {
        team1.school == matchup.team1 ? matchup.team2Wins : matchup.team1Wins
    }
    
    var firstTeamWinPercentage: Double {
        Double(firstTeamWins) / Double(totalGames)
    }
    
    var seconedTeamWinPercentage: Double {
        Double(secondTeamWins) / Double(totalGames)
    }
    
    var tiePercentage: Double {
        Double(matchup.ties) / Double(totalGames)
    }
    
    // MARK: - Matchup Games Info
    @Published var games: [MatchupGame]
    @Published var fullGames: [Game]
    
    var currentWinStreak: WinStreak? {
        guard !games.isEmpty else { return nil }
        
        let currentStreakWinner = games[0].awayScore > games[0].homeScore ? games[0].awayTeam : games[0].homeTeam
        let beginningDate = games[0].gameDate
        var endDate: Date?
        var currentStreak = 0
        
        for game in games {
            let winner = game.awayScore > game.homeScore ? game.awayTeam : game.homeTeam
            if winner == currentStreakWinner {
                currentStreak += 1
            } else {
                endDate = game.gameDate
                break
            }
        }
        
        let winningTeam = team1.school == currentStreakWinner ? team1 : team2
        return WinStreak(team: winningTeam, streak: currentStreak, beginningDate: beginningDate ?? Date(), endDate: endDate ?? Date())
    }
    
    @Injected(\.teamStore) private var teamStore
    @Injected(\.gameStore) private var gameStore
    @Injected(\.networkClient) private var networkClient
    
    init(matchup: Matchup, team1: Team, team2: Team) {
        self.matchup = matchup
        self.team1 = team1
        self.team2 = team2
        
        let store = InjectedValues[\.gameStore]
        games = (try? store.getMatchupGames(for: matchup.id).sorted(by: { $0.dateString > $1.dateString })) ?? []
        fullGames = (try? store.getAllGamesBetweenTeams(team1.school, team2.school)) ?? []
    }
    
    func getTeamLogo(for teamID: Int) -> UIImage? {
        guard let teamLogoData = try? teamStore.getTeamLogo(teamID: teamID),
              let teamLogo = UIImage(data: teamLogoData.logoData) else {
            return nil
        }
        
        return teamLogo
    }
    
    func fetchFullGameInfoBetweenTeams() async {
        guard !games.isEmpty else { return }
        
        for game in games {
            if let _ = try? gameStore.getGame(in: game.season, homeTeam: game.homeTeam, awayTeam: game.awayTeam) {
                continue
            } else {
                do {
                    print("API CALL: Game for \(game.homeTeam) - \(game.awayTeam) in \(game.season)")
                    try await handleGameRequest(in: game.season, homeTeam: game.homeTeam, awayTeam: game.awayTeam)
                } catch {
                    print(error)
                }
            }
        }
        
        await MainActor.run {
            fullGames = (try? gameStore.getAllGamesBetweenTeams(team1.school, team2.school)) ?? []
        }
    }
    
    private func handleGameRequest(in year: Int, homeTeam: String, awayTeam: String) async throws {
        try await networkClient.send(GameRequest.gamesYearTeams(year: year, homeTeam: homeTeam, awayTeam: awayTeam))
    }
}

struct WinStreak {
    let team: Team
    let streak: Int
    let beginningDate: Date
    let endDate: Date
}
