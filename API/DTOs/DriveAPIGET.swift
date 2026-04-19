//
//  DriveAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

struct DriveAPIGET: Codable, Identifiable {
    let id: String
    let gameID: Int
    let driveNumber: Int
    let plays: Int
    let yards: Int
    let isHomeOffense: Bool
    let driveResult: String
    
    enum CodingKeys: String, CodingKey {
        case id, driveNumber, plays, yards, isHomeOffense, driveResult
        case gameID = "gameId"
    }
    
    func toDrive() -> Drive {
        Drive(
            id: id,
            gameID: gameID,
            driveNumber: driveNumber,
            plays: plays,
            yards: yards,
            isHomeOffense: isHomeOffense,
            driveResult: driveResult
        )
    }
}
