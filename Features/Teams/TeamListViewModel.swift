//
//  TeamListViewModel.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI

@MainActor
class TeamListViewModel: ObservableObject {
    @Published var teams: [Team] = []
    @Published var isLoading: Bool = false
    @Published var errorMesssage: String?
    @Published var searchText: String = ""
    
    @Injected(\.networkClient) private var networkClient
    @Injected(\.teamStore) private var teamStore
    
    var searchResults: [Team] {
        if searchText.isEmpty {
            teams
        } else {
            teams.filter { $0.school.localizedCaseInsensitiveContains(searchText) || $0.mascot.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func loadTeams() async {
        if let databaseTeams = try? teamStore.allTeams(),
              !databaseTeams.isEmpty {
            teams = databaseTeams
        } else {
            isLoading = true
            
            do {
                print("API CALL FOR GETTeamRequest")
                try await networkClient.send(TeamRequest.teamsFBS)
                teams = try teamStore.allTeams()
                try await saveTeamLogos(teams)
            } catch {
                errorMesssage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func getTeamLogoData(for teamID: Int) -> Data? {
        guard let teamLogo = try? teamStore.getTeamLogo(teamID: teamID) else {
            return nil
        }
        
        return teamLogo.logoData
    }
    
    private func saveTeamLogos(_ teams: [Team]) async throws {
        try await withThrowingTaskGroup(of: (Int, Data).self) { group in
            for team in teams {
                guard let logoURL = team.logoURL else { continue }
                let teamID = team.id

                group.addTask {
                    let (data, response) = try await URLSession.shared.data(from: logoURL)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200..<300).contains(httpResponse.statusCode) else {
                        throw NetworkError.invalidResponse
                    }
                    
                    return (teamID, data)
                }
            }
            
            for try await (teamID, data) in group {
                try teamStore.saveTeamLogo(TeamLogo(id: UUID(), teamID: teamID, logoData: data))
            }
        }
    }
}
