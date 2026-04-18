//
//  TeamDetailsView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI
import UIKit

struct TeamDetailsView: View {
    @StateObject private var model: TeamDetailsViewModel
    
    init(model: TeamDetailsViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        // 1. NavigationStack removed — this view is already pushed onto
        //    TeamListView's NavigationStack via NavigationLink.
        ScrollView {
            VStack(spacing: 0) {
                teamHeader
                
                // 6. Centered loading state
                if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                // 7. Empty records state
                } else if model.records.isEmpty {
                    ContentUnavailableView(
                        "No Records",
                        systemImage: "chart.bar.xaxis",
                        description: Text("No historical records found for \(model.team.school).")
                    )
                    .padding(.top, 40)
                } else {
                    recordsGrid(for: model.records)
                }
            }
        }
        .navigationTitle(model.team.school)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await model.fetchRecord()
        }
    }
    
    // 2. Team header banner with logo, mascot, conference, and team color
    private var teamHeader: some View {
        HStack(spacing: 16) {
            if let data = model.teamLogoData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(model.team.mascot)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(model.team.conference)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(model.team.color.opacity(0.15))
    }
    
    private func recordsGrid(for records: [Record]) -> some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 12) {
            // 3. Styled header row
            GridRow {
                Text("Year")
                Text("Conference")
                Text("Record")
                Text("Schedule")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            
            // 4. Divider spanning full grid width between header and data
            Divider()
            
            ForEach(records, id: \.id) {
                gridRow(for: $0)
            }
        }
        .padding()
    }
    
    // 5. Data rows use .subheadline for dense tabular content
    private func gridRow(for record: Record) -> some View {
        GridRow {
            Text(String(record.year))
            Text(record.conference)
            Text(record.displayString)
            viewScheduleLink(for: record)
        }
        .font(.subheadline)
    }
    
    // 8. "View" text label instead of a bare arrow icon
    private func viewScheduleLink(for record: Record) -> some View {
        NavigationLink(destination:
            TeamScheduleView(viewModel:
                TeamScheduleViewModel(
                    teamName: record.team,
                    year: record.year,
                    teamID: record.teamID
                )
            )
        ) {
            Text("View")
                .foregroundStyle(.blue)
        }
    }
}
