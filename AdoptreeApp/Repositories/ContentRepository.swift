//
//  ContentRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ContentRepositoryProtocol {
    func getContents(using urlRequest: URLRequest) -> AnyPublisher<[Content], Error>
    func getContentByTitle(using urlRequest: URLRequest) -> AnyPublisher<[Content], Error>
}

class ContentRepository: ContentRepositoryProtocol {
    
    func getContentByTitle(using urlRequest: URLRequest) -> AnyPublisher<[Content], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getContents(using urlRequest: URLRequest) -> AnyPublisher<[Content], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
