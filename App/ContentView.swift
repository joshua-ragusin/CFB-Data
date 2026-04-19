//
//  ContentView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    typealias Identifier = ContentViewIdentifier
    
    var body: some View {
        TabView {
            TeamListView()
                .accessibilityID(Identifier.teams)
                .tabItem {
                    Label("Teams", systemImage: SFSymbol.listBulletinFill.value)
                }
            
            MatchupMainView()
                .accessibilityID(Identifier.matchups)
                .tabItem {
                    Label("Matchups", systemImage: SFSymbol.americanFootball.value)
                }
        }
        .environment(\.horizontalSizeClass, .compact)
        .tabViewStyle(.tabBarOnly)
    }
}
