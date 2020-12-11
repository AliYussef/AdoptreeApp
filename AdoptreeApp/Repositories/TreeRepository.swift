//
//  TreeRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol TreeRepositoryProtocol {
    func getAllTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error>
    func getATree(using urlRequest: URLRequest) -> AnyPublisher<Tree, Error>
    func getTreeImages(using urlRequest: URLRequest) -> AnyPublisher<Result<TreeImage, RequestError>, Never>
    func personalizeTree(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error>
    func renewTreeContract(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error>
    func getTreeSequestraion(using urlRequest: URLRequest) -> AnyPublisher<Result<[Double], RequestError>, Never>
}

class TreeRepository: TreeRepositoryProtocol {
    func getAllTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getATree(using urlRequest: URLRequest) -> AnyPublisher<Tree, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getTreeImages(using urlRequest: URLRequest) -> AnyPublisher<Result<TreeImage, RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func personalizeTree(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func renewTreeContract(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getTreeSequestraion(using urlRequest: URLRequest) -> AnyPublisher<Result<[Double], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    
}
