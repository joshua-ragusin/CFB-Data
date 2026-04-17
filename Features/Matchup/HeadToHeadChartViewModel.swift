//
//  HeadToHeadChartViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/30/26.
//

import Foundation
import SwiftUI

class HeadToHeadChartViewModel: ObservableObject {
    @Published var matchupGames: [MatchupGame] = []
    
    @Injected(\.gameStore) private var gameStore
    
    let positiveTeam: Team
    let negativeTeam: Team
    
    var pointDifferentials: [Int] {
        matchupGames.map { game in
            if positiveTeam.school == game.homeTeam {
                return game.homeScore - game.awayScore
            } else {
                return game.awayScore - game.homeScore
            }
        }
    }
    
    var yAxisDomain: ClosedRange<Int> {
        let max = pointDifferentials.max() ?? 0
        return -max...max
    }
    
    var xAxisDomain: ClosedRange<Int> {
        let calendar = Calendar.current
        
        if let endDate = matchupGames.last?.date,
           let startDate = matchupGames.first?.date {
            return calendar.component(.year, from: startDate)...calendar.component(.year, from: endDate)
        } else {
            return 0...0
        }
    }
    
    var yAxisStride: Double {
        let range = pointDifferentials.max() ?? 0
        let desiredSteps = 4
        return max(Double(1), Double(range) / Double(desiredSteps)).rounded()
    }
    
    init(matchupID: UUID, positiveTeam: Team, negativeTeam: Team) {
        self.positiveTeam = positiveTeam
        self.negativeTeam = negativeTeam

        matchupGames = (try? gameStore.getMatchupGames(for: matchupID).sorted { $0.dateString < $1.dateString }) ?? []
    }
    
    func getMatchupGameByYear(_ year: Int) -> MatchupGame? {
        let calendar = Calendar.current
        return matchupGames.first { calendar.component(.year, from: $0.date) == year }
    }
}
