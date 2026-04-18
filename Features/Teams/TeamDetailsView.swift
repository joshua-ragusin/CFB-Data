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
    
    typealias Identifier = TeamDetailsViewIdentifier
    
    init(model: TeamDetailsViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                teamHeader
                
                if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
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
        .accessibilityID(Identifier.seasonList)
    }
    
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
            GridRow {
                Text("Year")
                Text("Conference")
                Text("Record")
                Text("Schedule")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            
            Divider()
            
            ForEach(records, id: \.id) {
                gridRow(for: $0)
            }
        }
        .padding()
    }
    
    private func gridRow(for record: Record) -> some View {
        GridRow {
            Text(String(record.year))
            Text(record.conference)
            Text(record.displayString)
            viewScheduleLink(for: record)
        }
        .font(.subheadline)
    }
    
    private func viewScheduleLink(for record: Record) -> some View {
        NavigationLink(destination:
            TeamScheduleView(
                viewModel: TeamScheduleViewModel(record: record)
            )
        ) {
            Text("View")
                .foregroundStyle(.blue)
        }
    }
}
