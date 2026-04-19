//
//  PlayAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

struct PlayAPIGET: Codable {
    let id: String
    let driveID: String
    let gameID: Int
    let driveNumber: Int?
    let playNumber: Int?
    let offense: String
    let down: Int
    let distance: Int
    let yardLine: Int
    let playText: String?
    
    enum CodingKeys: String, CodingKey {
        case id, driveNumber, playNumber, offense, down, distance, playText
        case yardLine = "yardline"
        case driveID = "driveId"
        case gameID = "gameId"
    }
    
    func toPlay() -> Play {
        Play(id: id,
             driveID: driveID,
             gameID: gameID,
             driveNumber: driveNumber,
             playNumber: playNumber,
             offense: offense,
             down: down,
             distance: distance,
             yardLine: yardLine,
             playText: playText
        )
    }
}
