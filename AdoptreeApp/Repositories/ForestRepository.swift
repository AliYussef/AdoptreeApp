//
//  ForestRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ForestRepositoryProtocol {
    func getForests(using urlRequest: URLRequest) -> AnyPublisher<Result<[Forest], RequestError>, Never>
    func getWildlife(using urlRequest: URLRequest) -> AnyPublisher<Result<[Wildlife], RequestError>, Never>
}

class ForestRepository: ForestRepositoryProtocol {
    
    func getForests(using urlRequest: URLRequest) -> AnyPublisher<Result<[Forest], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func getWildlife(using urlRequest: URLRequest) -> AnyPublisher<Result<[Wildlife], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
