//
//  ContentView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        TabView {
            TeamListView()
                .tabItem {
                    Label("Teams", systemImage: SFSymbol.listBulletinFill.value)
                }
            
            MatchupMainView()
                .tabItem {
                    Label("Matchups", systemImage: SFSymbol.americanFootball.value)
                }
        }
        .environment(\.horizontalSizeClass, .compact)
        .tabViewStyle(.tabBarOnly)
    }
}
