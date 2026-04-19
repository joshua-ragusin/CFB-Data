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
            // Drive header
            Button(action: onTap) {
                HStack(spacing: 12) {
                    logoView
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(drive.driveResult.capitalized)
                            .font(.headline)
                            .foregroundStyle(driveResultColor)
                        
                        HStack(spacing: 12) {
                            Text("\(drive.yards) yds")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("\(drive.plays) plays")
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
            
            // Play list
            if isExpanded {
                Divider()
                
                if drive.groupedPlays.isEmpty {
                    Text("No play data available")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 16)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(drive.groupedPlays.enumerated()), id: \.element.id) { index, play in
                            playCard(for: play)
                            
                            if index < drive.groupedPlays.count - 1 {
                                Divider()
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var logoView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray.opacity(0.1))
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
            HStack(spacing: 12) {
                Text("\(ordinal(play.down)) & \(play.distance)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Text("Yd. \(play.yardLine)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if let playNumber = play.playNumber {
                    Text("Play \(playNumber)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Text(play.playDescription)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private var driveResultColor: Color {
        switch drive.driveResult.uppercased() {
        case "TOUCHDOWN":
            return .green
        case "FIELD GOAL":
            return .blue
        case "FUMBLE", "INTERCEPTION", "TURNOVER":
            return .red
        case "TURNOVER ON DOWNS", "MISSED FG":
            return .orange
        default:
            return .primary
        }
    }
    
    private func ordinal(_ n: Int) -> String {
        switch n {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        case 4: return "4th"
        default: return "\(n)th"
        }
    }
}
