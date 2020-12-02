//
//  CategoryRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol CategoryRepositoryProtocol {
    func getCategories(using urlRequest: URLRequest) -> AnyPublisher<[Category], Error>
}

class CategoryRepository: CategoryRepositoryProtocol {
    
    func getCategories(using urlRequest: URLRequest) -> AnyPublisher<[Category], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
