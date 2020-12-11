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
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never>
}

class UserRepository : UserRepositoryProtocol {
  
    func login(using urlRequest: URLRequest) -> AnyPublisher<LoginResponse, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getAdoptedTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func registerUser(using urlRequest: URLRequest) -> AnyPublisher<User, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func forgetPassword(using urlRequest: URLRequest) -> AnyPublisher<String, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func resetPassword(using urlRequest: URLRequest) -> AnyPublisher<User, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
}

