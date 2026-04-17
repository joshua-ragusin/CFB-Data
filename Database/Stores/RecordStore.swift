//
//  RecordStore.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation
import GRDB

class RecordStore: InjectionKey {
    static var currentValue = RecordStore()
    
    var queue: DatabaseQueue { DatabaseManager.shared.dbQueue }
    
    func saveRecord(_ record: Record) throws {
        try queue.write { db in
            try record.save(db)
        }
    }
    
    func saveRecordCategory(_ recordCategory: RecordCategory) throws {
        try queue.write { db in
            try recordCategory.save(db)
        }
    }
    
    func getRecords(for teamID: Int) throws -> [Record] {
        try queue.read { db in
            try Record
                .filter(Record.Columns.teamID == teamID)
                .order(Record.Columns.year.desc)
                .fetchAll(db)
        }
    }
    
    func getRecord(for teamID: Int, in year: Int) throws -> Record? {
        try queue.read { db in
            try Record
                .filter(Record.Columns.teamID == teamID)
                .filter(Record.Columns.year == year)
                .fetchOne(db)
        }
    }
    
    func getRecordCategory(with id: UUID) throws -> RecordCategory? {
        try queue.read { db in
            try RecordCategory
                .filter(RecordCategory.Columns.id == id)
                .fetchOne(db)
        }
    }
}
