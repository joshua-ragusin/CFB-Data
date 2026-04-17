//
//  HeadToHeadChartView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 1/30/26.
//

import SwiftUI
import Charts

struct HeadToHeadChartView: View {
    @StateObject private var viewModel: HeadToHeadChartViewModel
    
    @State private var selectedDate: Int?
    @State private var tooltipSize: CGSize = .zero
    
    init(viewModel: HeadToHeadChartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
        Swift.max(min, Swift.min(max, value))
    }
    
    var body: some View {
        Chart(viewModel.matchupGames) { game in
            let difference = game.scoreDifferential(team1Name: viewModel.positiveTeam.school, team2Name: viewModel.negativeTeam.school)

            BarMark(
                x: .value("x", Int(Calendar.current.component(.year, from: game.date))),
                y: .value("y", difference)
            )
            .foregroundStyle(difference > 0 ? Color(hex: viewModel.positiveTeam.hexColor) : Color(hex: viewModel.negativeTeam.hexColor))
        }
        .navigationTitle("Head to Head Results")
        .lockOrientation(.landscape)
        .chartXScale(domain: viewModel.xAxisDomain)
        .chartYScale(domain: viewModel.yAxisDomain)
        .chartXSelection(value: $selectedDate)
        .chartXAxis {
            AxisMarks(values: .stride(by: 10)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(values: .stride(by: viewModel.yAxisStride)) { value in
                if let y = value.as(Int.self),
                   y == 0 {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.black)
                } else {
                    AxisGridLine()
                        .foregroundStyle(.secondary.opacity(0.5))
                }
                
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                
                // Draws a line at Y = 0
                if let zeroX = proxy.position(forX: 0) {
                    Path { path in
                        path.move(to: CGPoint(x: zeroX, y: 0))
                        path.addLine(to: CGPoint(x: zeroX, y: geometry.size.height))
                    }
                    .stroke(.secondary, lineWidth: 1)
                }
                
                // Shows tooltip when a date is selected
                if let selectedDate,
                   let game = viewModel.getMatchupGameByYear(selectedDate) {
                    let barX = proxy.position(forX: selectedDate) ?? 0
                    let barY = proxy.position(forY: game.scoreDifferential(team1Name: viewModel.positiveTeam.school, team2Name: viewModel.negativeTeam.school)) ?? geometry.size.width / 2
                    
                    let isNearRightEdge = barX > geometry.size.width * 0.6
                    let desiredX = isNearRightEdge
                    ? barX - tooltipSize.width / 2 - 12
                    : barX + tooltipSize.width / 2 + 12

                    let clampedX = clamp(desiredX,
                                         min: tooltipSize.width / 2,
                                         max: geometry.size.width - tooltipSize.width / 2
                    )
                    
                    let clampedY = clamp(barY,
                                         min: tooltipSize.height / 2,
                                         max: geometry.size.height - tooltipSize.height / 2
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(game.date, format: .dateTime.month(.abbreviated).day().year())
                            .font(.caption)
                        Text(game.scoreTooltipText)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .padding(2)
                    .cornerRadius(10)
                    .border(.gray)
                    .background(.ultraThinMaterial)
                    .fixedSize()
                    .background(
                        GeometryReader { tooltipGeo in
                            Color.clear
                                .preference(
                                    key: ToolTipSizeKey.self,
                                    value: tooltipGeo.size
                                )
                        }
                    )
                    .onPreferenceChange(ToolTipSizeKey.self) {
                        tooltipSize = $0
                    }
                    .position(x: clampedX, y: clampedY)
                }
            }
        }
    }
}


/// Defines an item that can appear on the Head-to-Head chart
protocol HeadToHeadChartItem: Identifiable {
    /// Date the game took place (we'll only need the year)
    var date: Date { get }
    
    /// Function to find the score differential between the two teams
    func scoreDifferential(team1Name: String, team2Name: String) -> Int
}

struct ToolTipSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
