//
//  MatchupGame.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//
import Foundation
import GRDB

struct MatchupGame: Codable, Identifiable, Equatable {
    let id: UUID
    let season: Int
    let week: Int
    let dateString: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    
    enum CodingKeys: String, CodingKey {
        case id, season, week, homeTeam, awayTeam, homeScore, awayScore
        case dateString = "date"
    }
}

// MARK: GRDB

extension MatchupGame: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case season, week, homeTeam, awayTeam, homeScore, awayScore, id
        case dateString = "date"
    }
    
    static let matchup = belongsTo(Matchup.self)
    var matchup: QueryInterfaceRequest<Matchup> {
        request(for: Self.matchup)
    }
}

// MARK: Computed Vars

extension MatchupGame {
    var gameDate: Date? {
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateString.convertToDate(format: format)
    }
    
    var scoreTooltipText: String {
        if homeScore > awayScore {
            return "\(homeScore) - \(awayScore) \(homeTeam)"
        } else if awayScore > homeScore {
            return "\(homeScore) - \(awayScore) \(awayTeam)"
        } else {
            return "\(homeScore) - \(awayScore) TIE"
        }
    }
}

// MARK: Display on Head to head chart

extension MatchupGame: HeadToHeadChartItem {
    var date: Date {
        gameDate ?? Date()
    }
    
    func scoreDifferential(team1Name team1: String, team2Name team2: String) -> Int {
        if team1 == homeTeam {
            return homeScore - awayScore
        } else {
            return awayScore - homeScore
        }
    }
}
