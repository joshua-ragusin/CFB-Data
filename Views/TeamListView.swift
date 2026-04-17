//
//  TeamListView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI
import NukeUI
import UIKit

struct TeamListView: View {
    @StateObject private var model = TeamListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = model.errorMesssage {
                    Text(errorMessage)
                } else {
                    teamList
                }
            }
            .navigationTitle("Teams")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await model.loadTeams()
        }
    }
    
    private var teamList: some View {
        List(model.searchResults) {
            teamLink(for: $0)
        }
        .listStyle(.plain)
        .searchable(text: $model.searchText)
    }
    
    private func teamLink(for team: Team) -> some View {
        NavigationLink {
            TeamDetailsView(model: TeamDetailsViewModel(team: team))
                .toolbarVisibility(.hidden, for: .tabBar)
        } label: {
            HStack(spacing: 25) {
                if let data = model.getTeamLogoData(for: team.id),
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .padding(.horizontal)
                } else {
                    Image(symbol: .exclamationMarkTriangleFill)
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .center) {
                    Text(team.school)
                    Text(team.mascot)
                }
                
                Spacer()
            }
        }
    }
}
