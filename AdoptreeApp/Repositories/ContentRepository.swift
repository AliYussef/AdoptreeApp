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
    func getContentForGuest(using urlRequest: URLRequest) -> AnyPublisher<[Content], Error>
    
}

class ContentRepository: ContentRepositoryProtocol {
    
    func getContents(using urlRequest: URLRequest) -> AnyPublisher<Result<[Content], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func getContentForGuest(using urlRequest: URLRequest) -> AnyPublisher<[Content], Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
