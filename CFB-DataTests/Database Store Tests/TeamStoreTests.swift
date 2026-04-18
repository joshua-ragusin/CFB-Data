//
//  TeamStoreTests.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/28/26.
//

import XCTest
import GRDB

@testable import CFB_Data

class TeamStoreTests: XCTestCase {
    @Injected(\.teamStore) private var teamStore
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    override func tearDownWithError() throws {
        try queue.write { db in
            try TeamLogo
                .deleteAll(db)

            try Team
                .deleteAll(db)
        }
    }
    
    func testSaveTeam() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let team1 = makeTeam(id: team1ID)
        let team2 = makeTeam(id: team2ID)
        
        // Act
        try teamStore.saveTeam(team1)
        try teamStore.saveTeam(team2)
        
        let actualTeam1 = try queue.read { db in
            try Team
                .filter(Team.Columns.id == team1ID)
                .fetchOne(db)
        }
        
        let actualTeam2 = try queue.read { db in
            try Team
                .filter(Team.Columns.id == team2ID)
                .fetchOne(db)
        }
        
        // Assert
        XCTAssertEqual(team1, actualTeam1)
        XCTAssertEqual(team2, actualTeam2)
    }
    
    func testSaveTeamLogo() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let team1Logo = makeTeamLogo(teamID: team1ID)
        let team2Logo = makeTeamLogo(teamID: team2ID)
        
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        // Act
        try teamStore.saveTeamLogo(team1Logo)
        try teamStore.saveTeamLogo(team2Logo)
        
        let actualTeam1Logo = try queue.read { db in
            try TeamLogo
                .filter(TeamLogo.Columns.teamID == team1ID)
                .fetchOne(db)
        }
        
        let actualTeam2Logo = try queue.read { db in
            try TeamLogo
                .filter(TeamLogo.Columns.teamID == team2ID)
                .fetchOne(db)
        }
        
        // Assert
        XCTAssertEqual(team1Logo, actualTeam1Logo)
        XCTAssertEqual(team2Logo, actualTeam2Logo)
    }
    
    func testGetTeamBySchool() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let team1Name = "Team 1"
        let team2Name = "Team 2"
        let nonExistentTeamName = "Non Existent Team"
        
        let team1 = makeTeam(id: team1ID, school: team1Name)
        let team2 = makeTeam(id: team2ID, school: team2Name)
        
        try queue.write { db in
            try team1.save(db)
            try team2.save(db)
        }
        
        // Act
        let actualTeam1 = try teamStore.getTeam(school: team1Name)
        let actualTeam2 = try teamStore.getTeam(school: team2Name)
        let nonExistentTeam = try teamStore.getTeam(school: nonExistentTeamName)
        
        // Assert
        XCTAssertNil(nonExistentTeam)
        
        XCTAssertEqual(actualTeam1, team1)
        XCTAssertEqual(actualTeam2, team2)
    }
    
    func testGetTeamLogo() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        let unknowkTeamID = 100
        
        let teamLogo1 = makeTeamLogo(teamID: team1ID)
        let teamLogo2 = makeTeamLogo(teamID: team2ID)
        
        try insertTeam(with: team1ID)
        try insertTeam(with: team2ID)
        
        try queue.write { db in
            try teamLogo1.insert(db)
            try teamLogo2.insert(db)
        }
        
        // Act
        let actualTeam1Logo = try teamStore.getTeamLogo(teamID: team1ID)
        let actualTeam2Logo = try teamStore.getTeamLogo(teamID: team2ID)
        let actualUnknownTeamLogo = try teamStore.getTeamLogo(teamID: unknowkTeamID)
        
        // Assert
        XCTAssertNil(actualUnknownTeamLogo)
        XCTAssertEqual(teamLogo1, actualTeam1Logo)
        XCTAssertEqual(teamLogo2, actualTeam2Logo)
    }
    
    func testGetTeam_ByID() throws {
        // Arrange
        let team1ID = 1
        let team2ID = 2
        
        let unknownTeamID = 100
        
        let team1 = makeTeam(id: team1ID)
        let team2 = makeTeam(id: team2ID)
        
        try queue.write { db in
            try team1.save(db)
            try team2.save(db)
        }
        
        // Act
        let actualTeam1 = try teamStore.getTeam(by: team1ID)
        let actualTeam2 = try teamStore.getTeam(by: team2ID)
        
        let actualUnknownTeam = try teamStore.getTeam(by: unknownTeamID)
        
        
        // Assert
        XCTAssertNil(actualUnknownTeam)
        
        XCTAssertEqual(actualTeam1, team1)
        XCTAssertEqual(actualTeam2, team2)
    }
    
    // MARK: - Private helpers
    
    private func makeTeam(
        id: Int = 0,
        school: String = "",
        mascot: String = "",
        conference: String = "",
        hexColor: String = "",
        logos: [String] = []
    ) -> Team {
        Team(id: id,
             school: school,
             mascot: mascot,
             conference: conference,
             hexColor: hexColor,
             logos: logos
        )
    }
    
    private func insertTeam(with id: Int) throws {
        try queue.write { db in
            try makeTeam(id: id).insert(db)
        }
    }
    
    private func makeTeamLogo(
        id: UUID = UUID(),
        teamID: Int = 1,
        logoData: Data = Data()
    ) -> TeamLogo {
        TeamLogo(
            id: id,
            teamID: teamID,
            logoData: logoData
        )
    }
}
