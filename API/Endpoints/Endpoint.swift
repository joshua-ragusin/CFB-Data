//
//  Endpoint.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
}
