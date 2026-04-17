//
//  TeamStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//
import GRDB

class TeamStore: InjectionKey {
    static var currentValue = TeamStore()
    
    var queue: DatabaseQueue {
        DatabaseManager.shared.dbQueue
    }
    
    func saveTeam(_ team: Team) throws {
        try queue.write { db in
            try team.save(db)
        }
    }
    
    func saveTeamLogo(_ teamLogo: TeamLogo) throws {
        try queue.write { db in
            try teamLogo.save(db)
        }
    }
    
    func allTeams() throws -> [Team] {
        try queue.read { db in
            try Team
                .order(Team.Columns.school)
                .fetchAll(db)
        }
    }
    
    func getTeam(school: String) throws -> Team? {
        try queue.read { db in
            try Team
                .filter(Team.Columns.school == school)
                .fetchOne(db)
        }
    }
    
    func getTeam(by id: Int) throws -> Team? {
        try queue.read { db in
            try Team
                .filter(Team.Columns.id == id)
                .fetchOne(db)
        }
    }
    
    func getTeamLogo(teamID: Int) throws -> TeamLogo? {
        try queue.read { db in
            try TeamLogo
                .filter(TeamLogo.Columns.teamID == teamID)
                .fetchOne(db)
        }
    }
}
