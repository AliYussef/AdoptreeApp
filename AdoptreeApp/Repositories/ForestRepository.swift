//
//  ForestRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ForestRepositoryProtocol {
    func getWildlife(using urlRequest: URLRequest) -> AnyPublisher<Result<[Wildlife], RequestError>, Never>
}

class ForestRepository: ForestRepositoryProtocol {
    
    func getWildlife(using urlRequest: URLRequest) -> AnyPublisher<Result<[Wildlife], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
