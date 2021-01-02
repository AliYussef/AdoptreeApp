//
//  NetworkManager.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/01/2021.
//

import Foundation
import Combine

final class NetworkManager {
    static let sharedNetworkManager = NetworkManager()
    private let session: NetworkSession
    private let authenticator: Authenticator
    
    private init(session: NetworkSession = URLSession.shared) {
        self.session = session
        self.authenticator = Authenticator(session: session)
    }
    
    lazy var decoder: JSONDecoder = {
        let simpleDateFormatter = DateFormatter()
        simpleDateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let secondIsoDateFormatter = DateFormatter()
        secondIsoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        
        let serverFullDateFormatter = DateFormatter()
        serverFullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let len = dateStr.count
            var date: Date? = nil
            if simpleDateFormatter.date(from: dateStr) != nil {
                date = simpleDateFormatter.date(from: dateStr)
            } else if isoDateFormatter.date(from: dateStr) != nil {
                date = isoDateFormatter.date(from: dateStr)
            } else if secondIsoDateFormatter.date(from: dateStr) != nil {
                date = secondIsoDateFormatter.date(from: dateStr)
            } else {
                date = serverFullDateFormatter.date(from: dateStr)
            }
            guard let date_ = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return date_
        })
        return decoder
    }()
}

extension NetworkManager {
    
//    func getRefreshRequest() -> URLRequest? {
//        let fullUrl = BaseURL.url + ApiEndPoint.refreshToken.description
//        let url = URL(string: fullUrl)!
//        var urlRequest = URLRequest(url: url)
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let refreshToken = UserViewModel.shared.refreshToken {
//            urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
//        }
//        urlRequest.httpMethod = RequestMethod.post.rawValue
//
//        if let refreshToken = UserViewModel.shared.refreshToken {
//            urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authentication")
//            return urlRequest
//        }
//
//      return nil
//    }
    
    func executeRequestWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<ResponseType, Error> {
       
//        var urlRequest = request
//        if let accessToken = UserViewModel.shared.accessToken {
//            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        
        return authenticator.validToken()
            .flatMap({ token in
                // we can now use this token to authenticate the request
                self.session.publisher(for: request, token: token.accessToken)
            })
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                guard let serviceError = error as? RequestError,
                      serviceError.description == RequestError.invalidToken.description else {
                    
                    if let loginRequired = error as? AuthenticationError,
                       loginRequired.localizedDescription == AuthenticationError.loginRequired.localizedDescription {
                        
                        if UserViewModel.shared.accessToken != nil {
                            UserViewModel.shared.accessToken = nil
                            throw error
                        }
                        
                        return self.session.publisher(for: request, token: nil).eraseToAnyPublisher()
                    }
                    throw error
                }
                
                return self.authenticator.validToken(forceRefresh: true)
                    .flatMap({ token in
                        // we can now use this new token to authenticate the second attempt at making this request
                        self.session.publisher(for: request, token: token.accessToken)
                    })
                    .eraseToAnyPublisher()
            })
            .decode(type: ResponseType.self, decoder: self.decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func executeRequestsWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<Result<ResponseType, RequestError>, Never> {
        
//        var urlRequest = request
//        if let accessToken = UserViewModel.shared.accessToken {
//            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        
        return authenticator.validToken()
            .flatMap({ token in
                // we can now use this token to authenticate the request
                self.session.publisher(for: request, token: token.accessToken)
            })
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                guard let serviceError = error as? RequestError,
                      serviceError.description == RequestError.invalidToken.description else {
                    
                    if let loginRequired = error as? AuthenticationError,
                       loginRequired.localizedDescription == AuthenticationError.loginRequired.localizedDescription {
                        
                        if UserViewModel.shared.accessToken != nil {
                            UserViewModel.shared.accessToken = nil
                            throw error
                        }
                        
                        return self.session.publisher(for: request, token: nil).eraseToAnyPublisher()
                    }
                    throw error
                }
                
                return self.authenticator.validToken(forceRefresh: true)
                    .flatMap({ token in
                        // we can now use this new token to authenticate the second attempt at making this request
                        self.session.publisher(for: request, token: token.accessToken)
                    })
                    .eraseToAnyPublisher()
            })
            .decode(type: ResponseType.self, decoder: self.decoder)
            .map {
                .success($0)
            }
            .catch {
                error -> Just<Result<ResponseType, RequestError>> in
                if let urlError = error as? URLError {
                    return Just(.failure(RequestError.urlError(urlError)))
                } else if let decodingError = error as? DecodingError {
                    return Just(.failure(RequestError.decodingError(decodingError)))
                } else {
                    return Just(.failure(RequestError.genericError(error)))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func executeRequestWithoutResponseBody(using request: URLRequest) -> AnyPublisher<Data, Error> {
        
//        var urlRequest = request
//        if let accessToken = UserViewModel.shared.accessToken {
//            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        
        return authenticator.validToken()
            .flatMap({ token in
                // we can now use this token to authenticate the request
                self.session.publisher(for: request, token: token.accessToken)
            })
            .tryCatch({ error -> AnyPublisher<Data, Error> in
                guard let serviceError = error as? RequestError,
                      serviceError.description == RequestError.invalidToken.description else {
                    
                    if let loginRequired = error as? AuthenticationError,
                       loginRequired.localizedDescription == AuthenticationError.loginRequired.localizedDescription {
                        
                        if UserViewModel.shared.accessToken != nil {
                            UserViewModel.shared.accessToken = nil
                            throw error
                        }
                        
                        return self.session.publisher(for: request, token: nil).eraseToAnyPublisher()
                    }
                    throw error
                }
                
                return self.authenticator.validToken(forceRefresh: true)
                    .flatMap({ token in
                        // we can now use this new token to authenticate the second attempt at making this request
                        self.session.publisher(for: request, token: token.accessToken)
                    })
                    .eraseToAnyPublisher()
            })
            //.decode(type: ResponseType.self, decoder: self.decoder)
            //.compactMap {$0.response as? HTTPURLResponse}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        //        URLSession.shared.dataTaskPublisher(for: request)
        //            .compactMap { $0.response as? HTTPURLResponse }
        //            .receive(on: DispatchQueue.main)
        //            .eraseToAnyPublisher()
    }
    
}
