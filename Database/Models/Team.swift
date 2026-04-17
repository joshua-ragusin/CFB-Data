//
//  Team.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//
import SwiftUI
import GRDB

struct Team: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let school: String
    let mascot: String
    let conference: String
    let hexColor: String
    let logos: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, school, mascot, conference, logos
        case hexColor = "color"
    }
}

extension Team: FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, mascot, school, conference, logos, hexColor
    }
    
    static let records = hasMany(Record.self)
    static let recordCategory = hasMany(RecordCategory.self)
}

extension Team {
    var color: Color {
        Color(hex: hexColor)
    }
    
    var logoURL: URL? {
        for logo in logos {
            if let url = URL(string: logo) {
                return url
            }
        }
        
        return nil
    }
    
    var displayString: String {
        "\(school) \(mascot)"
    }
}
