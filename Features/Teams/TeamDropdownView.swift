//
//  TeamDropdownView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI
import NukeUI

struct TeamDropdownView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedTeam: Team?
    
    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var options = [Team]()
    
    @Injected(\.teamStore) private var teamStore
    
    typealias Identifier = TeamDropdownViewIdentifier
    
    var filteredOptions: [Team] {
        if searchText.isEmpty {
            options
        } else {
            options.filter { $0.mascot.localizedCaseInsensitiveContains(searchText) || $0.school.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(team selectedTeam: Binding<Team?>) {
        _selectedTeam = selectedTeam
    }
    
    var body: some View {
        NavigationStack {
            List(filteredOptions, id: \.id) {
                listCell(for: $0)
            }
            .accessibilityID(Identifier.teamList)
            .searchable(text: $searchText)
            .listStyle(.plain)
        }
        .navigationTitle("Select a team")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: selectedTeam) { _, _ in
            dismiss()
        }
        .onAppear {
            options = (try? teamStore.allTeams()) ?? []
        }
    }
    
    private func listCell(for team: Team) -> some View {
        Button {
            selectedTeam = team
        } label: {
            HStack {
                LazyImage(url: team.logoURL) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if state.error != nil {
                        Image(symbol: .exclamationMarkTriangleFill)
                            .backgroundStyle(.red)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .center) {
                    Text(team.school)
                    Text(team.mascot)
                }
                
                Spacer()
                
                if (selectedTeam ?? nil) == team {
                    Image(symbol: .checkmark)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

