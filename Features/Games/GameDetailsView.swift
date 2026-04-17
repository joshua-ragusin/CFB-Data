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
    
    private var homeTeam: String { viewModel.winProbabilityPlays.first?.home ?? "Home" }
    private var awayTeam: String { viewModel.winProbabilityPlays.first?.away ?? "Away" }
    
    init(viewModel: GameDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                chartView
            }
        }
        .task {
            await viewModel.fetchWinProbabilityPlays()
        }
    }
    
    private var chartView: some View {
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
            
            // center baseline
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
        .padding()
    }
}
