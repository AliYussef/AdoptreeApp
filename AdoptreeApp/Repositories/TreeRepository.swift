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
    func getActualImage(using urlRequest: URLRequest) -> AnyPublisher<Data, Error>
    func personalizeTree(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error>
    func renewTreeContract(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error>
    func getTreeSequestraion(using urlRequest: URLRequest) -> AnyPublisher<Result<[Double], RequestError>, Never>
}

class TreeRepository: TreeRepositoryProtocol {
    func getAllTrees(using urlRequest: URLRequest) -> AnyPublisher<[Tree], Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getATree(using urlRequest: URLRequest) -> AnyPublisher<Tree, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getTreeImages(using urlRequest: URLRequest) -> AnyPublisher<Result<TreeImage, RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func getActualImage(using urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithoutAuthenticator(using: urlRequest)
    }
    
    func personalizeTree(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func renewTreeContract(using urlRequest: URLRequest) -> AnyPublisher<AssignedTree, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getTreeSequestraion(using urlRequest: URLRequest) -> AnyPublisher<Result<[Double], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
