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
    func registerUser(using urlRequest: URLRequest) -> AnyPublisher<User, Error>
    func forgetPassword(using urlRequest: URLRequest) -> AnyPublisher<String, Error>
    func resetPassword(using urlRequest: URLRequest) -> AnyPublisher<User, Error>
    func updateUserAccount(using urlRequest: URLRequest) -> AnyPublisher<User, Error>
    func deleteUserAccount(using urlRequest: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError>
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never>
    func getUserById(using urlRequest: URLRequest) -> AnyPublisher<User, Error>
    func refreshToken(using urlRequest: URLRequest) -> AnyPublisher<RefreshTokenResponse, Error>
}

class UserRepository : UserRepositoryProtocol {
    
    func login(using urlRequest: URLRequest) -> AnyPublisher<LoginResponse, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getAdoptedTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func registerUser(using urlRequest: URLRequest) -> AnyPublisher<User, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func forgetPassword(using urlRequest: URLRequest) -> AnyPublisher<String, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func resetPassword(using urlRequest: URLRequest) -> AnyPublisher<User, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func updateUserAccount(using urlRequest: URLRequest) -> AnyPublisher<User, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func deleteUserAccount(using urlRequest: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> {
        return ApiClient.sharedApiClient.executeRequestWithoutResponseBody(using: urlRequest)
    }
    
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func getUserById(using urlRequest: URLRequest) -> AnyPublisher<User, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func refreshToken(using urlRequest: URLRequest) -> AnyPublisher<RefreshTokenResponse, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBodyRefresh(using: urlRequest)
    }
}

