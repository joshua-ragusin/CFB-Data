//
//  DriveRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/19/26.
//

enum DriveRequest {
    case drives(year: Int, week: Int, seasonType: String, team: String, gameID: Int)
}

extension DriveRequest: APIRequest {
    var endpoint: DriveEndpoint {
        switch self {
        case .drives(let year, let week, let seasonType, let team, _):
            .drives(year: year, week: week, seasonType: seasonType, team: team)
        }
    }
    
    func handleResponse(_ response: [DriveAPIGET]) throws {
        switch self {
        case .drives(_, _, _, _, let gameID):
            handleDriveResponse(response, gameID: gameID)
        }
    }
    
    private func handleDriveResponse(_ response: [DriveAPIGET], gameID: Int) {
        @Injected(\.driveStore) var driveStore
        
        for apiDrive in response where apiDrive.gameID == gameID {
            if let _ = try? driveStore.getDrive(id: apiDrive.id) {
                continue
            }
            try? driveStore.saveDrive(apiDrive.toDrive())
        }
    }
}
