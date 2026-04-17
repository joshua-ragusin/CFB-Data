//
//  TeamDetailsView.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import SwiftUI

struct TeamDetailsView: View {
    @StateObject private var model: TeamDetailsViewModel
    
    init(model: TeamDetailsViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !model.isLoading {
                    gridView(for: model.records)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(model.team.school)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await model.fetchRecord()
            }
        }
    }
    
    private func gridView(for records: [Record]) -> some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                Text("Year")
                Text("Conference")
                Text("Record")
                Text("")
            }
            
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
    }
    
    private func viewScheduleLink(for record: Record) -> some View {
        NavigationLink(destination:
                        TeamScheduleView(viewModel:
                                            TeamScheduleViewModel(teamName: record.team,
                                                                  year: record.year,
                                                                  teamID: record.teamID
                                                                 )
                                        )
        ) {
            Image(symbol: .arrowShapeRightFill)
        }
    }
}
