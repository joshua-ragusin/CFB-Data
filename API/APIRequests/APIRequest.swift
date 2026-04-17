//
//  APIRequest.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//
import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    associatedtype E: Endpoint
    var endpoint: E { get }
    
    func handleResponse(_ response: Response) throws
}

extension APIRequest {
    var url: URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        
        if let parameters = endpoint.parameters {
            var queryItems = [URLQueryItem]()
            for parameter in parameters {
                queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
            }
            
            components.queryItems = queryItems
        }
        
        return components.url
    }
}
