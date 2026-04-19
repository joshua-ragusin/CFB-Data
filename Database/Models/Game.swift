//
//  Game.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

import GRDB
import Foundation

struct Game: Codable {
    let id: Int
    let season: Int
    let seasonType: String
    let homeID: Int?
    let homeTeam: String
    let awayID: Int?
    let awayTeam: String
    let homePoints: Int
    let awayPoints: Int
    let dateString: String
    let neutralSite: Bool
    let notes: String?
    let homeLineScores: [Int]
    let awayLineScores: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, season, seasonType, homeID, homeTeam, awayID, awayTeam, homePoints, awayPoints, notes, neutralSite, homeLineScores, awayLineScores
        case dateString = "date"
    }
}


// MARK: - GRDB
extension Game: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, season, seasonType, homeID, homeTeam, awayID, awayTeam, homePoints, awayPoints, notes, neutralSite, homeLineScores, awayLineScores
        case dateString = "date"
    }
}

extension Game: Identifiable {}

// MARK: - Computed Vars
extension Game {
    var homeTeamInitials: String {
        homeTeam.initialized()
    }
    
    var awayTeamInitials: String {
        awayTeam.initialized()
    }
    
    var scoreString: String {
        "\(homePoints) - \(awayPoints)"
    }
    
    var date: Date? {
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateString.convertToDate(format: format)
    }
}
