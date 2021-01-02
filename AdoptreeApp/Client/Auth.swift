////
////  Auth.swift
////  AdoptreeApp
////
////  Created by Ali Yussef on 02/01/2021.
////
//
//import Foundation
//import Combine
//
//struct Token: Decodable {
//    let isValid: Bool
//}
//
////struct Response: Decodable {
////    let message: String
////}
////
////enum ServiceErrorMessage: String, Decodable, Error {
////    case invalidToken = "invalid_token"
////}
////
////struct ServiceError: Decodable, Error {
////    let errors: [ServiceErrorMessage]
////}
//
//protocol NetworkSession: AnyObject {
//    func publisher(for url: URLRequest, token: String?) -> AnyPublisher<Data, Error>
//    //    func executeRequestWithResponseBody<ResponseType: Decodable>(using request: URLRequest, token: Token?) -> AnyPublisher<ResponseType, Error>
//    //    func executeRequestsWithResponseBody<ResponseType: Decodable>(using request: URLRequest, token: Token?) -> AnyPublisher<Result<ResponseType, RequestError>, Never>
//    //    func executeRequestWithoutResponseBody(using request: URLRequest, token: Token?) -> AnyPublisher<HTTPURLResponse, URLError>
//}
//
//extension URLSession: NetworkSession {
//    
//    func publisher(for request: URLRequest, token: String?) -> AnyPublisher<Data, Error> {
//        var urlRequest = request
//        
//        if let token = token {
//            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
//        }
//        
//        return dataTaskPublisher(for: urlRequest)
//            .tryMap { data, response -> Data in
//                guard let httpResponse = response as? HTTPURLResponse,
//                      200...299 ~= httpResponse.statusCode else {
//                    print("request: \(urlRequest), response: \(response)")
//                    throw RequestError.invalidToken
//                }
//                print("request: \(urlRequest), response: \(response)")
//                return data
//            }
//            .eraseToAnyPublisher()
//    }
//}
//
//struct NetworkManager {
//    static let sharedApiClient = NetworkManager()
//    
//    lazy var decoder: JSONDecoder = {
//        let simpleDateFormatter = DateFormatter()
//        simpleDateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
//        
//        let isoDateFormatter = DateFormatter()
//        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        
//        let secondIsoDateFormatter = DateFormatter()
//        secondIsoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
//        
//        let serverFullDateFormatter = DateFormatter()
//        serverFullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
//            let container = try decoder.singleValueContainer()
//            let dateStr = try container.decode(String.self)
//            
//            let len = dateStr.count
//            var date: Date? = nil
//            if simpleDateFormatter.date(from: dateStr) != nil {
//                date = simpleDateFormatter.date(from: dateStr)
//            } else if isoDateFormatter.date(from: dateStr) != nil {
//                date = isoDateFormatter.date(from: dateStr)
//            } else if secondIsoDateFormatter.date(from: dateStr) != nil {
//                date = secondIsoDateFormatter.date(from: dateStr)
//            } else {
//                date = serverFullDateFormatter.date(from: dateStr)
//            }
//            guard let date_ = date else {
//                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
//            }
//            return date_
//        })
//        return decoder
//    }()
//    
//    private let session: NetworkSession
//    private let authenticator: Authenticator
//    
//    private init(session: NetworkSession = URLSession.shared) {
//        self.session = session
//        self.authenticator = Authenticator(session: session)
//    }
//    
//    func executeRequestWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<ResponseType, Error> {
//        //let url = URL(string: "https://donnys-app.com/authenticated/resource")!
//        
//        return authenticator.validToken()
//            .flatMap({ token in
//                // we can now use this token to authenticate the request
//                session.publisher(for: request, token: token.accessToken)
//            })
//            .tryCatch({ error -> AnyPublisher<Data, Error> in
//                guard let serviceError = error as? RequestError,
//                      serviceError.description == RequestError.invalidToken.description else {
//                    print(error)
//                    if let loginRequired = error as? AuthenticationError,
//                       loginRequired.localizedDescription == AuthenticationError.loginRequired.localizedDescription {
//                        
//                        return session.publisher(for: request, token: nil).eraseToAnyPublisher()
//                    }
//                    UserViewModel.shared.accessToken = nil
//                    throw URLError(.userAuthenticationRequired)
//                }
//                
//                return authenticator.validToken(forceRefresh: true)
//                    .flatMap({ token in
//                        // we can now use this new token to authenticate the second attempt at making this request
//                        session.publisher(for: request, token: token.accessToken)
//                    })
//                    .eraseToAnyPublisher()
//            })
//            .decode(type: ResponseType.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//}
//
//class Authenticator {
//    private let session: NetworkSession
//    private var currentToken: Token? = Token(isValid: false)
//    
//    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")
//    
//    // this publisher is shared amongst all calls that request a token refresh
//    private var refreshPublisher: AnyPublisher<RefreshTokenResponse, Error>?
//    
//    init(session: NetworkSession = URLSession.shared) {
//        self.session = session
//    }
//    
//    func validToken(forceRefresh: Bool = false) -> AnyPublisher<RefreshTokenResponse, Error> {
//        return queue.sync { [weak self] in
//            // scenario 1: we're already loading a new token
//            if let publisher = self?.refreshPublisher {
//                return publisher
//            }
//            
//            // scenario 2: we don't have a token at all, the user should probably log in
//            guard let token = UserViewModel.shared.accessToken else {
//                return Fail(error: AuthenticationError.loginRequired)
//                    .eraseToAnyPublisher()
//            }
//            
//            // scenario 3: we already have a valid token and don't want to force a refresh
//            let isTokenValid = UserViewModel.shared.checkTokenValidity()
//            if isTokenValid, !forceRefresh {
//                if let refreshToken = UserViewModel.shared.refreshToken {
//                    return Just(RefreshTokenResponse(accessToken: token, refreshToken: refreshToken))
//                        .setFailureType(to: Error.self)
//                        .eraseToAnyPublisher()
//                }
//            }
//            
//            // scenario 4: we need a new token
//            //let endpoint = URL(string: "https://donnys-app.com/token/refresh")!
//            let fullUrl = BaseURL.url + ApiEndPoint.refreshToken.description
//            let url = URL(string: fullUrl)!
//            var urlRequest = URLRequest(url: url)
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            urlRequest.httpMethod = RequestMethod.post.rawValue
//            
//            guard let refreshToken = UserViewModel.shared.refreshToken else {
//                return Fail(error: RequestError.invalidToken)
//                    .eraseToAnyPublisher()
//            }
//            
//            let publisher = session.publisher(for: urlRequest, token: refreshToken)
//                .share()
//                .decode(type: RefreshTokenResponse.self, decoder: JSONDecoder())
//                .handleEvents(receiveOutput: { refreshTokenResponse in
//                    // self?.currentToken = token
//                    print("Update")
//                    UserViewModel.shared.accessToken = refreshTokenResponse.accessToken
//                    UserViewModel.shared.refreshToken = refreshTokenResponse.refreshToken
//                    UserViewModel.shared.authenDate = String(Date().timeIntervalSince1970)
//                }, receiveCompletion: { _ in
//                    self?.queue.sync {
//                        self?.refreshPublisher = nil
//                    }
//                })
//                .eraseToAnyPublisher()
//            
//            self?.refreshPublisher = publisher
//            return publisher
//        }
//    }
//}
//
////enum AuthenticationError: Error {
////    case loginRequired
////}
