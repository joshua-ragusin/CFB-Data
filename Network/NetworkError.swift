//
//  NetworkError.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError(message: String)
    case invalidResponse
    case serverError(statusCode: Int)
    case dbError(message: String)
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError(message: let message):
            return "Decoding Error: \(message)"
        case .invalidResponse:
            return "Invalid Response"
        case .serverError(statusCode: let code):
            return "Server Error (\(code))"
        case .dbError(message: let message):
            return "Database Error: \(message)"
        default:
            return "Unknown Error"
        }
    }
}
