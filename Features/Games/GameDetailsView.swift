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
            await viewModel.fetchDrives()
        }
    }
    
    // MARK: - Drives Views
    
    private var drivesView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.drives, id: \.id) { drive in
                driveView(for: drive)
            }
        }
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
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isChartExpanded ? 0 : -90))
                        .animation(.easeInOut(duration: 0.2), value: isChartExpanded)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            
            if isChartExpanded {
                Divider()
                
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
                    Text(homeTeam)
                        .foregroundStyle(.blue)
                        .font(.caption)
                        .padding(8)
                }
                .overlay(alignment: .topTrailing) {
                    Text(awayTeam)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(8)
                }
                .frame(height: 220)
                .padding()
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
}
