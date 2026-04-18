//
//  RecordStoreTests.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/29/26.
//

import XCTest
import GRDB

@testable import CFB_Data

class RecordStoreTests: XCTestCase {
    @Injected(\.recordStore) private var recordStore
    
    typealias CFBRecord = CFB_Data.Record
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    override func tearDownWithError() throws {
        try queue.write { db in
            try CFBRecord
                .deleteAll(db)
            
            try RecordCategory
                .deleteAll(db)
            
            try Team
                .deleteAll(db)
        }
    }
    
    func testSaveRecord() throws {
        // Arrange
        let record1ID = UUID()
        let record2ID = UUID()
        
        let team1ID = 1
        let team2ID = 2
        
        let conferenceRecordCategory1ID = UUID()
        let totalRecordCategory1ID = UUID()
        
        let conferenceRecordCategory2ID = UUID()
        let totalRecordCategory2ID = UUID()
        
        let record1 = makeRecord(id: record1ID, teamID: team1ID, conferenceRecordID: conferenceRecordCategory1ID, totalRecordID: totalRecordCategory1ID)
        let record2 = makeRecord(id: record2ID, teamID: team2ID, conferenceRecordID: conferenceRecordCategory2ID, totalRecordID: totalRecordCategory2ID)
        
        // Act
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        try insertRecordCategory(with: conferenceRecordCategory1ID, teamID: team1ID)
        try insertRecordCategory(with: totalRecordCategory1ID, teamID: team1ID)
        
        try insertRecordCategory(with: conferenceRecordCategory2ID, teamID: team2ID)
        try insertRecordCategory(with: totalRecordCategory2ID, teamID: team2ID)
        
        try recordStore.saveRecord(record1)
        try recordStore.saveRecord(record2)
        
        let actualRecord1 = try queue.read { db in
            try CFBRecord
                .filter(CFBRecord.Columns.id == record1ID)
                .fetchOne(db)
        }
        
        let actualRecord2 = try queue.read { db in
            try CFBRecord
                .filter(CFBRecord.Columns.id == record2ID)
                .fetchOne(db)
        }
        
        // Assert
        XCTAssertEqual(actualRecord1, record1)
        XCTAssertEqual(actualRecord2, record2)
    }
    
    func testSaveRecordCategory() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let recordCategory1ID = UUID()
        let recordCategory2ID = UUID()
        
        let recordCategory1 = makeRecordCategory(id: recordCategory1ID, teamID: team1ID)
        let recordCategory2 = makeRecordCategory(id: recordCategory2ID, teamID: team2ID)
        
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        // Act
        try recordStore.saveRecordCategory(recordCategory1)
        try recordStore.saveRecordCategory(recordCategory2)
        
        let actualRecordCategory1 = try queue.read { db in
            try RecordCategory
                .filter(RecordCategory.Columns.id == recordCategory1ID)
                .fetchOne(db)
        }
        
        let actualRecordCategory2 = try queue.read { db in
            try RecordCategory
                .filter(RecordCategory.Columns.id == recordCategory2ID)
                .fetchOne(db)
        }
        
        // Assert
        XCTAssertEqual(recordCategory1, actualRecordCategory1)
        XCTAssertEqual(recordCategory2, actualRecordCategory2)
    }
    
    func testGetRecordCategory_ByID() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let recordCategory1ID = UUID()
        let recordCategory2ID = UUID()
        
        let recordCategory1 = makeRecordCategory(id: recordCategory1ID, teamID: team1ID)
        let recordCategory2 = makeRecordCategory(id: recordCategory2ID, teamID: team2ID)
        
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        try queue.write { db in
            try recordCategory1.save(db)
            try recordCategory2.save(db)
        }
        
        let actualRecordCategory1 = try recordStore.getRecordCategory(with: recordCategory1ID)
        let actualRecordCategory2 = try recordStore.getRecordCategory(with: recordCategory2ID)
        
        // Act
        XCTAssertEqual(recordCategory1, actualRecordCategory1)
        XCTAssertEqual(recordCategory2, actualRecordCategory2)
    }
    
    func testGetRecord_ByTeamAndYear() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let validYear = 0
        let invalidYear = 1
        
        let conferenceRecordCategories = (1...2).map { makeRecordCategory(teamID: $0) }
        let totalRecordCatoeogies = (1...2).map { makeRecordCategory(teamID: $0) }
        
        let record1 = makeRecord(teamID: team1ID, year: validYear, conferenceRecordID: conferenceRecordCategories[0].id, totalRecordID: totalRecordCatoeogies[0].id)
        let record2 = makeRecord(teamID: team2ID, year: validYear, conferenceRecordID: conferenceRecordCategories[1].id, totalRecordID: totalRecordCatoeogies[1].id)
        
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        try queue.write { db in
            for recordCategory in conferenceRecordCategories {
                try recordCategory.save(db)
            }
            
            for recordCategory in totalRecordCatoeogies {
                try recordCategory.save(db)
            }
            
            try record1.save(db)
            try record2.save(db)
        }
        
        // Act
        let actualRecord1 = try recordStore.getRecord(for: team1ID, in: validYear)
        let actualRecord2 = try recordStore.getRecord(for: team2ID, in: validYear)
        
        let invalidRecord = try recordStore.getRecord(for: team1ID, in: invalidYear)
        
        // Assert
        XCTAssertNil(invalidRecord)
        
        XCTAssertEqual(record1, actualRecord1)
        XCTAssertEqual(record2, actualRecord2)
    }
    
    func testGetRecords_ByTeamID() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        let unknownTeamID = 100
        
        let conferenceRecord1Categories = (1...3).map { _ in makeRecordCategory(teamID: team1ID) }
        let totalRecord1Categories = (1...3).map { _ in makeRecordCategory(teamID: team1ID) }
        
        let conferenceRecord2Categories = (1...2).map { _ in makeRecordCategory(teamID: team2ID) }
        let totalRecord2Categories = (1...2).map { _ in makeRecordCategory(teamID: team2ID) }
        
        let team1Records = (1...3).map { makeRecord(teamID: team1ID, conferenceRecordID: conferenceRecord1Categories[$0 - 1].id, totalRecordID: totalRecord1Categories[$0 - 1].id) }
        let team2Records = (1...2).map { makeRecord(teamID: team2ID, conferenceRecordID: conferenceRecord2Categories[$0 - 1].id, totalRecordID: totalRecord2Categories[$0 - 1].id) }
        
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        try queue.write { db in
            for recordCategory in conferenceRecord1Categories + conferenceRecord2Categories + totalRecord1Categories + totalRecord2Categories {
                try recordCategory.save(db)
            }
            
            for record in team1Records + team2Records {
                try record.save(db)
            }
        }
        
        // Act
        let actualRecords1 = try recordStore.getRecords(for: team1ID)
        let actualRecords2 = try recordStore.getRecords(for: team2ID)
        
        let actualUnknownTeamRecords = try recordStore.getRecords(for: unknownTeamID)
        
        // Assert
        XCTAssertEqual(actualUnknownTeamRecords.count, 0)
        
        XCTAssertEqual(actualRecords1.count, team1Records.count)
        XCTAssertEqual(actualRecords1, team1Records)
        
        XCTAssertEqual(actualRecords2.count, team2Records.count)
        XCTAssertEqual(actualRecords2, team2Records)
    }
    
    // MARK: - Private methods
    
    private func makeRecord(
        id: UUID = UUID(),
        teamID: Int = 1,
        year: Int = 0,
        team: String = "",
        conference: String = "",
        conferenceRecordID: UUID = UUID(),
        totalRecordID: UUID = UUID()
    ) -> CFBRecord {
        CFBRecord(
            id: id,
            teamID: teamID,
            year: year,
            team: team,
            conference: conference,
            conferenceRecordID: conferenceRecordID,
            totalRecordID: totalRecordID
        )
    }
    
    private func makeRecordCategory(
        id: UUID = UUID(),
        teamID: Int = 1,
        games: Int = 0,
        wins: Int = 0,
        losses: Int = 0,
        ties: Int = 0
    ) -> RecordCategory {
        RecordCategory(
            id: id,
            teamID: teamID,
            games: games,
            wins: wins,
            losses: losses,
            ties: ties
        )
    }
    
    private func makeTeam(
        id: Int = 1,
        school: String = "",
        mascot: String = "",
        conference: String = "",
        hexColor: String = "",
        logos: [String] = []
    ) -> Team {
        Team(
            id: id,
            school: school,
            mascot: mascot,
            conference: conference,
            hexColor: hexColor,
            logos: logos
        )
    }
    
    private func insertTeam(with id: Int) throws {
        try queue.write { db in
            try makeTeam(id: id).save(db)
        }
    }
    
    private func insertRecordCategory(with id: UUID, teamID: Int = 1) throws {
        try queue.write { db in
            try makeRecordCategory(id: id).save(db)
        }
    }
    
    private func insertRecord(with id: UUID) throws {
        try queue.write { db in
            try makeRecord(id: id).save(db)
        }
    }
}
