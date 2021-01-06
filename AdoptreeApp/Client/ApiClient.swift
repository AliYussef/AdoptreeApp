////
////  ApiClient.swift
////  AdoptreeApp
////
////  Created by Ali Yussef on 01/12/2020.
////
//
//import Foundation
//import Combine
//
//final class ApiClient {
//    static let sharedApiClient = ApiClient()
//    //private var cancellable: AnyCancellable?
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
//    private init() {}
//}
//
//extension ApiClient {
//
////    func refreshToken() {
////        let fullUrl = BaseURL.url + ApiEndPoint.refreshToken.description
////        let url = URL(string: fullUrl)!
////        var urlRequest = URLRequest(url: url)
////        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
////        if let accessToken = UserViewModel.shared.refreshToken {
////            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
////        }
////        urlRequest.httpMethod = RequestMethod.post.rawValue
////
////        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
////            .map({ $0.data })
////            .decode(type: RefreshTokenResponse.self, decoder: self.decoder)
////            .receive(on: DispatchQueue.main)
////            .sink(receiveCompletion: { result in
////                switch result {
////                    case .finished:
////                        break
////                    case .failure(let error):
////                        switch error {
////                            case let urlError as URLError:
////                                print(urlError)
////                            case let decodingError as DecodingError:
////                                UserViewModel.shared.accessToken = nil
////                                print(decodingError)
////                            default:
////                                print(error)
////                        }
////                }
////            }, receiveValue: { result in
////                print(result)
////                UserViewModel.shared.accessToken = result.accessToken
////                UserViewModel.shared.refreshToken = result.refreshToken
////            })
////
////    }
//    func publisher(for request: URLRequest) -> AnyPublisher<Data, Error> {
////        var urlRequest = request
////
////        if let token = UserViewModel.shared.accessToken {
////            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
////        }
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response -> Data in
//                guard let httpResponse = response as? HTTPURLResponse,
//                      200...299 ~= httpResponse.statusCode else {
//                    print("request: \(request), response: \(response)")
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
//                print("request: \(request), response: \(response)")
//                return data
//            }
//            .eraseToAnyPublisher()
//    }
//
//    func validToken(forceRefresh: Bool = false) -> AnyPublisher<RefreshTokenResponse, Error> {
//        return DispatchQueue.global().sync { [weak self] in
//            // scenario 1: we're already loading a new token
////            if let publisher = self?.refreshPublisher {
////                return publisher
////            }
//
//            // scenario 2: we don't have a token at all, the user should probably log in
//            guard let token = UserViewModel.shared.accessToken else {
////                return Fail(error: AuthenticationError.loginRequired)
////                    .eraseToAnyPublisher()
//                return Just(RefreshTokenResponse(accessToken: nil, refreshToken: nil))
//                    .setFailureType(to: Error.self)
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
//            let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
//                .tryMap { data, response -> Data in
//                    guard let httpResponse = response as? HTTPURLResponse,
//                          200...299 ~= httpResponse.statusCode else {
//                        print("request: \(urlRequest), response: \(response)")
//                        switch (response as! HTTPURLResponse).statusCode {
//                            case 401:
//                                throw RequestError.invalidToken
//                            case 500:
//                                throw AuthenticationError.loginRequired
//                            default:
//                                throw URLError(.badServerResponse)
//                        }
//
//                    }
//                    print("request: \(urlRequest), response: \(response)")
//                    return data
//                }
//                .share()
//                .decode(type: RefreshTokenResponse.self, decoder: JSONDecoder())
//                .handleEvents(receiveOutput: { refreshTokenResponse in
//                    // self?.currentToken = token
//                    print("Update")
//                    UserViewModel.shared.authenDate = String(Date().timeIntervalSince1970)
//                    UserViewModel.shared.accessToken = refreshTokenResponse.accessToken
//                    UserViewModel.shared.refreshToken = refreshTokenResponse.refreshToken
//                }, receiveCompletion: { _ in
////                    self?.queue.sync {
////                        self?.refreshPublisher = nil
////                    }
//                })
//                .eraseToAnyPublisher()
//
//           // self?.refreshPublisher = publisher
//            return publisher
//        }
//    }
//
//    func executeRequestWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<ResponseType, Error> {
//        var requests = request
//        if let accessToken = UserViewModel.shared.accessToken {
//            requests.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
//
//        return validToken()
//            .flatMap({ token in
//                // we can now use this token to authenticate the request
//                self.publisher(for: requests)
//            })
////            .tryCatch({ error -> AnyPublisher<Data, Error> in
////                guard let serviceError = error as? RequestError,
////                      serviceError.description == RequestError.invalidToken.description else {
////
////                    if let loginRequired = error as? AuthenticationError,
////                       loginRequired.localizedDescription == AuthenticationError.loginRequired.localizedDescription {
////
////                        if UserViewModel.shared.accessToken != nil {
////                            UserViewModel.shared.accessToken = nil
////                            throw error
////                        }
////
////                        return self.publisher(for: request).eraseToAnyPublisher()
////                    }
////                    throw error
////                }
////
////                return self.validToken(forceRefresh: true)
////                    .flatMap({ token in
////                        // we can now use this new token to authenticate the second attempt at making this request
////                        self.publisher(for: request)
////                    })
////                    .eraseToAnyPublisher()
////            })
//            .decode(type: ResponseType.self, decoder: self.decoder)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//
////        return URLSession.shared.dataTaskPublisher(for: requests)
////            .tryMap { data, response -> Data in
////                //~= pattern match operator
////                guard let httpResponse = response as? HTTPURLResponse,
////                      200...299 ~= httpResponse.statusCode else {
////                    print("request: \(request), response: \(response)")
////                    switch (response as! HTTPURLResponse).statusCode {
////                        case 401:
////                           // self.refreshToken()
////                            throw URLError(.userAuthenticationRequired)
////                        default:
////                            throw URLError(.badServerResponse)
////                    }
////
////                }
////                print("request: \(request), response: \(response)")
////                return data
////            }
////            .decode(type: ResponseType.self, decoder: self.decoder)
////            .receive(on: DispatchQueue.main)
////            .eraseToAnyPublisher()
//    }
//
//    func executeRequestsWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<Result<ResponseType, RequestError>, Never> {
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response -> Data in
//
//                guard let httpResponse = response as? HTTPURLResponse,
//                      200...299 ~= httpResponse.statusCode else {
//                    throw URLError(.badServerResponse)
//                }
//                //print("request: \(request), response: \(response)")
//                return data
//            }
//            .decode(type: ResponseType.self, decoder: self.decoder)
//            .map {
//                .success($0)
//            }
//            .catch { error -> Just<Result<ResponseType, RequestError>> in
//                if let urlError = error as? URLError {
//                    return Just(.failure(RequestError.urlError(urlError)))
//                } else if let decodingError = error as? DecodingError {
//                    return Just(.failure(RequestError.decodingError(decodingError)))
//                } else {
//                    return Just(.failure(RequestError.genericError(error)))
//                }
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//
//    func executeRequestWithoutResponseBody(using request: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> {
//
//        URLSession.shared.dataTaskPublisher(for: request)
//            .compactMap { $0.response as? HTTPURLResponse }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//
//    func executeRequestWithResponseBodyRefresh<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<ResponseType, Error> {
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response -> Data in
//                guard let httpResponse = response as? HTTPURLResponse,
//                      200...299 ~= httpResponse.statusCode else {
//
//                    switch (response as! HTTPURLResponse).statusCode {
//                        case 401:
//                            throw URLError(.userAuthenticationRequired)
//                        default:
//                            throw URLError(.badServerResponse)
//                    }
//                }
//                return data
//            }
//            .decode(type: ResponseType.self, decoder: self.decoder)
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .eraseToAnyPublisher()
//    }
//}
//
//
//
//
//
