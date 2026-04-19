//
//  BoxScoreAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

import Foundation

struct GameAPIGET: Codable {
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
    let week: Int
    
    enum CodingKeys: String, CodingKey {
        case id, season, seasonType, homeTeam, awayTeam, homePoints, awayPoints, neutralSite, notes, homeLineScores, awayLineScores, week
        case homeID = "homeId"
        case awayID = "awayId"
        case dateString = "startDate"
    }
    
    init(apiGame: GameAPIGET, homeID: Int?, awayID: Int?) {
        self.id = apiGame.id
        self.season = apiGame.season
        self.seasonType = apiGame.seasonType
        self.homeID = homeID
        self.homeTeam = apiGame.homeTeam
        self.awayID = awayID
        self.awayTeam = apiGame.awayTeam
        self.dateString = apiGame.dateString
        self.neutralSite = apiGame.neutralSite
        self.notes = apiGame.notes
        self.homePoints = apiGame.homePoints
        self.awayPoints = apiGame.awayPoints
        self.homeLineScores = apiGame.homeLineScores
        self.awayLineScores = apiGame.awayLineScores
        self.week = apiGame.week
    }
}

extension GameAPIGET {
    func toGame() -> Game {
        Game(
            id: id,
            season: season,
            seasonType: seasonType,
            homeID: homeID,
            homeTeam: homeTeam,
            awayID: awayID,
            awayTeam: awayTeam,
            homePoints: homePoints,
            awayPoints: awayPoints,
            dateString: dateString,
            neutralSite: neutralSite,
            notes: notes,
            homeLineScores: homeLineScores,
            awayLineScores: awayLineScores,
            week: week
        )
    }
}
