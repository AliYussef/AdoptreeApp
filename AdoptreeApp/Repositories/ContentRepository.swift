//
//  ContentRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ContentRepositoryProtocol {
    func getContents(using urlRequest: URLRequest) -> AnyPublisher<Result<[Content], RequestError>, Never>
    
}

class ContentRepository: ContentRepositoryProtocol {
    
    func getContents(using urlRequest: URLRequest) -> AnyPublisher<Result<[Content], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
