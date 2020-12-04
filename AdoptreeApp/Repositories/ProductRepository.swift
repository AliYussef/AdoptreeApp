//
//  ProductRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ProductRepositoryProtocol {
    func getProducts(using urlRequest: URLRequest) -> AnyPublisher<[Product], Error>
}

class ProductRepository: ProductRepositoryProtocol {
    
    func getProducts(using urlRequest: URLRequest) -> AnyPublisher<[Product], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
