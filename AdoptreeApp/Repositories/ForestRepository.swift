//
//  ForestRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ForestRepositoryProtocol {
    func getWildlife(using urlRequest: URLRequest) -> AnyPublisher<[Wildlife], Error>
}

class ForestRepository: ForestRepositoryProtocol {
    
    func getWildlife(using urlRequest: URLRequest) -> AnyPublisher<[Wildlife], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
