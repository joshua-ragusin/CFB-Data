//
//  TeamDetailsViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import SwiftUI

class TeamDetailsViewModel: ObservableObject {
    @Published var records = [Record]()
    @Published var isLoading = false

    @Injected(\.networkClient) private var networkClient
    @Injected(\.recordStore) private var recordStore
    @Injected(\.teamStore) private var teamStore
    
    let team: Team
    
    var teamLogoData: Data? {
        try? teamStore.getTeamLogo(teamID: team.id)?.logoData
    }
    
    init(team: Team) {
        self.team = team
    }
    
    func fetchRecord() async {
        await MainActor.run {
            isLoading = true
        }
        
        if let dbRecords = try? recordStore.getRecords(for: team.id),
           !dbRecords.isEmpty{
            await MainActor.run {
                records = dbRecords
            }
        } else {
            do {
                print("API CALL: Fetching records for \(team.school)...")
                try await networkClient.send(RecordRequest.records(team: team.school))
            } catch {
                print(error)
            }
            
            let fetchedRecords = (try? recordStore.getRecords(for: team.id)) ?? []
            
            await MainActor.run {
                records = fetchedRecords
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    func fetchBoxScores(for team: String, in year: Int) async {
        do {
            print("API CALL: Fetching box scores for \(team) in \(year)")
            try await networkClient.send(GameRequest.gamesTeams(team: team, year: year))
        } catch {
            print(error)
        }
    }
}
