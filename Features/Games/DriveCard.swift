//
//  DriveCard.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

import SwiftUI

struct DriveCard: View {
    let drive: Drive
    let isExpanded: Bool
    let offenseTeamID: Int
    let onTap: () -> Void
    
    @Injected(\.teamStore) private var teamStore
    
    var teamLogoData: Data? {
        try? teamStore.getTeamLogo(teamID: offenseTeamID)?.logoData
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Driver header
            Button(action: onTap) {
                HStack(spacing: 12) {
                    logoView
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(drive.driveResult)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        HStack(spacing: 12) {
                            Text(String(drive.yards))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("\(String(drive.plays)) plays")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(symbol: isExpanded ? .chevronUp : .chevronDown)
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .contentShape(Rectangle())
            }
            .background(.gray.opacity(0.1))
            
            // Play info
            if isExpanded {
                Divider()
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(drive.groupedPlays, id: \.id) { play in
                        playCard(for: play)
                    }
                }
            }
        }
    }
    
    private var logoView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
//                .fill(team.color.opacity(0.15))
                .frame(width: 60, height: 60)
            
            if let data = teamLogoData,
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
    
    private func playCard(for play: Play) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(play.down ?? 0) & \(play.distance ?? 0)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text("Yard line: \(play.yardLine ?? 0)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Text(play.playText)
                .font(.body)
                .lineLimit(2)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 8)
    }
}
