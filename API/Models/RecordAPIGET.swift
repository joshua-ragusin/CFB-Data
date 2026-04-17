//
//  RecordAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation

struct RecordAPIGET: Codable {
    let id = UUID()
    let teamID: Int
    let year: Int
    let team: String
    let conference: String
    let conferenceRecord: RecordCategoryAPIGet
    let totalRecord: RecordCategoryAPIGet
    
    enum CodingKeys: String, CodingKey {
        case id, team, conference, year
        case teamID = "teamId"
        case totalRecord = "total"
        case conferenceRecord = "conferenceGames"
    }
    
    func toRecord() -> Record {
        Record(id: id,
               teamID: teamID,
               year: year,
               team: team,
               conference: conference,
               conferenceRecordID: conferenceRecord.toRecordCategory(teamID: teamID).id,
               totalRecordID: totalRecord.toRecordCategory(teamID: teamID).id)
    }
}

struct RecordCategoryAPIGet: Codable {
    let id = UUID()
    let games: Int
    let wins: Int
    let losses: Int
    let ties: Int
    
    enum CodingKeys: String, CodingKey {
        case id, games, wins, losses, ties
    }
    
    func toRecordCategory(teamID: Int) -> RecordCategory {
        RecordCategory(id: id,
                       teamID: teamID,
                       games: games,
                       wins: wins,
                       losses: losses,
                       ties: ties)
    }
}
