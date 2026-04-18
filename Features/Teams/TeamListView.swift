//
//  TeamListView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI
import UIKit

struct TeamListView: View {
    @StateObject private var model = TeamListViewModel()
    
    typealias Identifier = TeamListViewIdentifier
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = model.errorMesssage {
                    errorView(message: errorMessage)
                } else {
                    teamList
                }
            }
            .navigationTitle("Teams")
            .navigationBarTitleDisplayMode(.large)
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
        .overlay {
            if !model.searchText.isEmpty && model.searchResults.isEmpty {
                ContentUnavailableView.search(text: model.searchText)
                    .accessibilityID(Identifier.noResults)
                    .accessibilityElement(children: .combine)
            }
        }
        .accessibilityID(Identifier.teamList)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(symbol: .exclamationMarkTriangleFill)
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(.red)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Retry") {
                Task { await model.loadTeams() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func teamLink(for team: Team) -> some View {
        NavigationLink {
            TeamDetailsView(model: TeamDetailsViewModel(team: team))
                .toolbarVisibility(.hidden, for: .tabBar)
        } label: {
            HStack(spacing: 16) {
                logoView(for: team)

                VStack(alignment: .leading, spacing: 2) {
                    Text(team.school)
                        .font(.headline)
                    Text(team.mascot)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(team.conference)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    private func logoView(for team: Team) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(team.color.opacity(0.15))
                .frame(width: 60, height: 60)
            
            if let data = model.getTeamLogoData(for: team.id),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
            } else {
                Image(symbol: .exclamationMarkTriangleFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.red)
            }
        }
    }
}
