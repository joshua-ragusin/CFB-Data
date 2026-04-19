//
//  GameScoreboard.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import SwiftUI

struct GameScoreboard: View {
    
    let game: Game
    
    private let scoreColumnWidth: CGFloat = 38
    
    // Use at least 4 columns; expand for overtime
    private var quarterCount: Int {
        max(4, max(game.homeLineScores.count, game.awayLineScores.count))
    }
    
    private func periodLabel(for index: Int) -> String {
        switch index {
        case 0...3: return "Q\(index + 1)"
        case 4: return "OT"
        default: return "\(index - 3)OT"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerRow
            Divider()
            teamRow(name: game.homeTeam, lineScores: game.homeLineScores, total: game.homePoints, totalColor: .blue)
            Divider()
            teamRow(name: game.awayTeam, lineScores: game.awayLineScores, total: game.awayPoints, totalColor: .red)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.separator, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var headerRow: some View {
        HStack(spacing: 0) {
            Text("Team")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(0..<quarterCount, id: \.self) { index in
                Text(periodLabel(for: index))
                    .frame(width: scoreColumnWidth)
            }
            
            Text("T")
                .frame(width: scoreColumnWidth)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func teamRow(name: String, lineScores: [Int], total: Int, totalColor: Color) -> some View {
        HStack(spacing: 0) {
            Text(name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .font(.subheadline)
            
            ForEach(0..<quarterCount, id: \.self) { index in
                Text(index < lineScores.count ? "\(lineScores[index])" : "-")
                    .frame(width: scoreColumnWidth)
                    .font(.subheadline)
            }
            
            Text("\(total)")
                .frame(width: scoreColumnWidth)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(totalColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
