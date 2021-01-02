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
                    print("request: \(request), response: \(response)")
                    switch (response as! HTTPURLResponse).statusCode {
                        case 401:
                            throw RequestError.invalidToken
                        case 500:
                            throw AuthenticationError.loginRequired
                        default:
                            throw URLError(.badServerResponse)
                    }
                    
                }
                
                print("request: \(request), response: \(response)")
                return data
            }
            .eraseToAnyPublisher()
        
        
    }
    
    //    func publisherWithNoResponse(for request: URLRequest, token: String?) -> AnyPublisher<HTTPURLResponse, Error> {
    //        var urlRequest = request
    //
    //        if let token = token {
    //            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
    //        }
    //
    //        return dataTaskPublisher(for: urlRequest)
    //            .tryMap { response -> HTTPURLResponse in
    //                guard let httpResponse = response as? HTTPURLResponse,
    //                      200...299 ~= httpResponse.statusCode else {
    //                    print("request: \(urlRequest), response: \(response)")
    //                    switch (response as! HTTPURLResponse).statusCode {
    //                        case 401:
    //                            throw RequestError.invalidToken
    //                        case 500:
    //                            throw AuthenticationError.loginRequired
    //                        default:
    //                            throw URLError(.badServerResponse)
    //                    }
    //
    //                }
    //                print("request: \(urlRequest), response: \(response)")
    //                return data
    //            }
    //            .eraseToAnyPublisher()
    //    }
}
