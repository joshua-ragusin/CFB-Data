//
//  NetworkManager.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//

import Foundation

final class NetworkClient: InjectionKey {
    static var currentValue = NetworkClient()
    
    func send<T: APIRequest>(_ request: T) async throws {
        guard let url = request.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.endpoint.method.rawValue
        
        if let headers = request.endpoint.headers {
            urlRequest.allHTTPHeaderFields = headers
            print(headers)
        }
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw NetworkError.unknown(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        let decodedResponse: T.Response
        
        do {
            decodedResponse = try JSONDecoder().decode(T.Response.self, from: data)
        } catch {
            let nsError = error as NSError
            throw NetworkError.decodingError(message: nsError.debugDescription)
        }
        
        do {
            try request.handleResponse(decodedResponse)
        } catch {
            let nsError = error as NSError
            throw NetworkError.dbError(message: nsError.debugDescription)
        }
        
    }
}

