//
//  Authenticator.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/01/2021.
//

import Foundation
import Combine

class Authenticator {
    private let session: NetworkSession
    //private var currentToken: Token? = Token(isValid: false)
    
    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")
    
    // this publisher is shared amongst all calls that request a token refresh
    private var refreshPublisher: AnyPublisher<RefreshTokenResponse, Error>?
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func validToken(forceRefresh: Bool = false) -> AnyPublisher<RefreshTokenResponse, Error> {
        return queue.sync { [weak self] in
            // scenario 1: we're already loading a new token
            if let publisher = self?.refreshPublisher {
                return publisher
            }
            
            // scenario 2: we don't have a token at all, the user should probably log in
            guard let token = UserViewModel.shared.accessToken else {
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }
            
            // scenario 3: we already have a valid token and don't want to force a refresh
            let isTokenValid = UserViewModel.shared.checkTokenValidity()
            if isTokenValid, !forceRefresh {
                if let refreshToken = UserViewModel.shared.refreshToken {
                    return Just(RefreshTokenResponse(accessToken: token, refreshToken: refreshToken))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            
            // scenario 4: we need a new token
            let fullUrl = BaseURL.url + ApiEndPoint.refreshToken.description
            let url = URL(string: fullUrl)!
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = RequestMethod.post.rawValue

            guard let refreshToken = UserViewModel.shared.refreshToken else {
                //replace with login. if we do not have refresh token then we need to login
                return Fail(error: AuthenticationError.loginRequired)
                    .eraseToAnyPublisher()
            }
            urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
            
            let publisher = session.publisher(for: urlRequest, token: nil)
                .share()
                .decode(type: RefreshTokenResponse.self, decoder: JSONDecoder())
                .handleEvents(receiveOutput: { refreshTokenResponse in
                    // self?.currentToken = token
                    print("Update")
                    UserViewModel.shared.authenDate = String(Date().timeIntervalSince1970)
                    UserViewModel.shared.accessToken = refreshTokenResponse.accessToken
                    UserViewModel.shared.refreshToken = refreshTokenResponse.refreshToken
                }, receiveCompletion: { _ in
                    print("Completed")
                    self?.queue.sync {
                        self?.refreshPublisher = nil
                    }
                })
                //.receive(on: DispatchQueue.global(qos: .userInitiated))
                .eraseToAnyPublisher()
            
            self?.refreshPublisher = publisher
            return publisher
        }
    }
    
//    func refreshToken() -> AnyPublisher<RefreshTokenResponse, Error> {
//
//    }
}

