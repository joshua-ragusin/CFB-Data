//
//  DriveRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum DriveRequest {
    case drives(year: Int, week: Int, team: String)
}

extension DriveRequest: APIRequest {
    var endpoint: DriveEndpoint {
        switch self {
        case .drives(let year, let week, let team):
                .drives(year: year, week: week, team: team)
        }
    }
    
    func handleResponse(_ response: [DriveAPIGET]) throws {
        switch self {
        case .drives(_, _, _):
            handleDriveResponse(response)
        }
    }
    
    private func handleDriveResponse(_ response: [DriveAPIGET]) {
        @Injected(\.driveStore) var driveStore
        
        for apiDrive in response {
            if let _ = try? driveStore.getDrive(id: apiDrive.id) {
                continue
            }
            
            try? driveStore.saveDrive(apiDrive.toDrive())
        }
    }
}
