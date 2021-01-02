//
//  TreeSignRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 11/12/2020.
//

import Foundation
import Combine

protocol TreeSignRepositoryProtocol {
    func createTreeSign(using urlRequest: URLRequest) -> AnyPublisher<TreeSign, Error>
    func getTreeSignByTree(using urlRequest: URLRequest) -> AnyPublisher<TreeSign, Error>
}

class TreeSignRepository: TreeSignRepositoryProtocol {
    
    func createTreeSign(using urlRequest: URLRequest) -> AnyPublisher<TreeSign, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getTreeSignByTree(using urlRequest: URLRequest) -> AnyPublisher<TreeSign, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
}
