//
//  TeamAPIGET.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

struct TeamAPIGET: Codable {
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
    
    func toTeam() -> Team {
        Team(
             id: id,
             school: school,
             mascot: mascot,
             conference: conference,
             hexColor: hexColor,
             logos: logos
        )
    }
}
