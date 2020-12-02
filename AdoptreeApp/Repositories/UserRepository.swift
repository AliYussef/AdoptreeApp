//
//  UserRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func login(using urlRequest: URLRequest) -> AnyPublisher<LoginResponse, Error>
    func getAdoptedTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error>
    //func registerUser(using urlRequest: URLRequest) -> AnyPublisher<URLResponse, Error>
}

class UserRepository : UserRepositoryProtocol {
    
    func login(using urlRequest: URLRequest) -> AnyPublisher<LoginResponse, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getAdoptedTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    
}

// second way
//final class UserService {
//    static let sharedUserService = UserService()
//    private init() {}
//    //    func login(requestType: RequestType, endpoint: ApiEndPoint, user: User) -> AnyPublisher<URLResponse, Error> {
//    //        let urlString = BaseURL.url + endpoint.description
//    //        let url = URL(string: urlString)!
//    //        var urlRequest = URLRequest(url: url)
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    //        urlRequest.httpMethod = requestType.rawValue
//    //        //guard let body = try? JSONEncoder().encode(User) else {}
//    //        do {
//    //            let body = try JSONEncoder().encode(user)
//    //            urlRequest.httpBody = body
//    //        } catch let error {
//    //            if let decoding = error as? EncodingError {
//    //                return .
//    //            }
//    //           // return error
//    //        }
//    //    }
//
//    func login(using urlRequest: URLRequest) -> AnyPublisher<LoginResponse, Error> {
//
//        return ApiClient.sharedApiClient.executeRequest(using: urlRequest)
//    }
//
//}
