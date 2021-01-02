//
//  CategoryRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol CategoryRepositoryProtocol {
    func getCategories(using urlRequest: URLRequest) -> AnyPublisher<Result<[Category], RequestError>, Never>
}

class CategoryRepository: CategoryRepositoryProtocol {
    
    func getCategories(using urlRequest: URLRequest) -> AnyPublisher<Result<[Category], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
