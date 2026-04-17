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
    
    enum CodingKeys: String, CodingKey {
        case id, season, seasonType, homeTeam, awayTeam, homePoints, awayPoints, neutralSite, notes
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
            notes: notes
        )
    }
}
