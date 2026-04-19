//
//  GameDetailsView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/17/26.
//

import SwiftUI
import Charts

// TODO: The API doesn't return win probabilities for older games find a way to restrict access to this view based on the game date.

struct GameDetailsView: View {
    @StateObject private var viewModel: GameDetailsViewModel
    
    @State private var isChartExpanded: Bool = true
    @State private var expandedDriveID: String?
    
    private var homeTeam: String { viewModel.winProbabilityPlays.first?.home ?? "Home" }
    private var awayTeam: String { viewModel.winProbabilityPlays.first?.away ?? "Away" }
    
    init(viewModel: GameDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    GameScoreboard(game: viewModel.game)
                    chartView
                    drivesView
                }
            }
            .padding(.vertical)
        }
        .task {
            await viewModel.fetchWinProbabilityPlays()
            await viewModel.fetchPlays()
            await viewModel.fetchDrives()
        }
    }
    
    // MARK: - Drives Views
    
    private var drivesView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Drives")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
            
            ForEach(viewModel.drives, id: \.id) { drive in
                driveView(for: drive)
            }
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
    
    private func driveView(for drive: Drive) -> some View {
        DriveCard(
            drive: drive,
            isExpanded: expandedDriveID == drive.id,
            offenseTeamID: drive.isHomeOffense ? viewModel.homeID : viewModel.awayID
        ) {
            withAnimation(.snappy) {
                expandedDriveID = expandedDriveID == drive.id ? nil : drive.id
            }
        }
    }
    
    // MARK: - Chart View
    
    private var chartView: some View {
        VStack(spacing: 0) {
            // Disclosure header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isChartExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("Win Probability")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(symbol: isChartExpanded ? .chevronUp : .chevronDown)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            if isChartExpanded {
                Divider()
                
                if viewModel.winProbabilityPlays.isEmpty {
                    Text("Win probability data is not available for this game.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                } else {
                    Chart {
                        // Shaded area under the line
                        ForEach(viewModel.winProbabilityPlays) { play in
                            AreaMark(
                                x: .value("Play", play.playNumber),
                                yStart: .value("Probability", 0),
                                yEnd: .value("Probability", play.divergingProbability)
                            )
                            .foregroundStyle(
                                play.divergingProbability >= 0
                                ? Color.blue.opacity(0.2)
                                : Color.red.opacity(0.2)
                            )
                            .interpolationMethod(.catmullRom)
                        }
                        
                        // Line on top of area
                        ForEach(viewModel.winProbabilityPlays) { play in
                            LineMark(
                                x: .value("Play", play.playNumber),
                                y: .value("Probability", play.divergingProbability)
                            )
                            .foregroundStyle(
                                play.divergingProbability >= 0
                                ? Color.blue
                                : Color.red
                            )
                            .interpolationMethod(.catmullRom)
                        }
                        
                        // Center baseline
                        RuleMark(y: .value("Even", 0))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(.secondary)
                    }
                    .chartYScale(domain: -50...50)
                    .chartYAxis {
                        AxisMarks(values: [-50, -25, 0, 25, 50]) { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let v = value.as(Double.self) {
                                    let label = v == 0 ? "50/50" : "\(abs(Int(v + 50)))%"
                                    Text(label)
                                }
                            }
                        }
                    }
                    .chartXAxis(.hidden)
                    .overlay(alignment: .topLeading) {
                        teamLabel(name: homeTeam, color: .blue)
                    }
                    .overlay(alignment: .topTrailing) {
                        teamLabel(name: awayTeam, color: .red)
                    }
                    .frame(height: 220)
                    .padding()
                }
            }
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
    
    private func teamLabel(name: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(name)
                .foregroundStyle(color)
                .font(.caption)
        }
        .padding(8)
    }
}
