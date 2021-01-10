//
//  NetworkSession.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/01/2021.
//

import Foundation
import Combine

protocol NetworkSession: AnyObject {
    func publisher(for url: URLRequest, token: String?) -> AnyPublisher<Data, Error>
}

extension URLSession: NetworkSession {
    
    func publisher(for request: URLRequest, token: String?) -> AnyPublisher<Data, Error> {
        var urlRequest = request
        
        if let token = token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    
                    /* remove this later */
                    print("request: \(urlRequest), response: \(response), data: \(String(data: data, encoding: .utf8)!.components(separatedBy: .newlines))")
                    
                    
                    switch (response as! HTTPURLResponse).statusCode {
                        case 401:
                            throw RequestError.invalidToken
                        case 500:
                            throw AuthenticationError.loginRequired
                        default:
                            throw URLError(.badServerResponse)
                    }
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
}
