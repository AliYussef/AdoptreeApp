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
                    
                    switch (response as! HTTPURLResponse).statusCode {
                        case 401:
                            throw RequestError.invalidToken
                        case 403:
                            DispatchQueue.main.async {
                                UserViewModel.shared.accessToken = nil
                                UserViewModel.shared.refreshToken = nil
                                UserViewModel.shared.isAuthenticated = false
                            }
                            throw AuthenticationError.loginRequired
                        case 502,503:
                            throw RequestError.serverError
                        default:
                            throw URLError(.badServerResponse)
                    }
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
}
