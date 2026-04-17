//
//  RecordRequestT.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

enum RecordRequest {
    case records(team: String)
}

extension RecordRequest: APIRequest {
    var endpoint: RecordEndpoint {
        switch self {
        case .records(let team):
                .records(team: team)
        }
    }
    
    func handleResponse(_ response: [RecordAPIGET]) throws {
        switch self {
        case .records(_):
            try handleRecordResponse(response)
        }
    }
    
    private func handleRecordResponse(_ response: [RecordAPIGET]) throws {
        @Injected(\.recordStore) var recordStore
        
        for apiRecord in response {
            if (try recordStore.getRecord(for: apiRecord.teamID, in: apiRecord.year)) == nil {
                try recordStore.saveRecordCategory(apiRecord.conferenceRecord.toRecordCategory(teamID: apiRecord.teamID))
                try recordStore.saveRecordCategory(apiRecord.totalRecord.toRecordCategory(teamID: apiRecord.teamID))
                try recordStore.saveRecord(apiRecord.toRecord())
            }
        }
    }
}
