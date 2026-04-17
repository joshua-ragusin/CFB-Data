//
//  APIConfig.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 4/16/26.
//

actor APIConfig {
    static let shared = APIConfig()
    nonisolated(unsafe) private(set) var cfbDataToken: String?
    
    func configure() {
        cfbDataToken = KeychainHelper.load() ?? ""
    }
}
