//
//  Record.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation
import GRDB

struct Record: Codable, Equatable, Identifiable {
    let id: UUID
    let teamID: Int
    let year: Int
    let team: String
    let conference: String
    let conferenceRecordID: UUID
    let totalRecordID: UUID
}

extension Record: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, teamID, year, team, conference, conferenceRecordID, totalRecordID
    }
}

extension Record {
    var conferenceRecord: RecordCategory? {
        @Injected(\.recordStore) var recordStore
        return try? recordStore.getRecordCategory(with: conferenceRecordID)
    }
    
    var totalRecord: RecordCategory? {
        @Injected(\.recordStore) var recordStore
        return try? recordStore.getRecordCategory(with: totalRecordID)
    }
    
    var displayString: String {
        if let conferenceRecord = conferenceRecord, let totalRecord = totalRecord {
            return "\(totalRecord.displayString) (\(conferenceRecord.displayString))"
        } else {
            return ""
        }
    }
}
