//
//  ProductRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol ProductRepositoryProtocol {
    func getProducts(using urlRequest: URLRequest) -> AnyPublisher<Result<[Product], RequestError>, Never>
}

class ProductRepository: ProductRepositoryProtocol {
    
    func getProducts(using urlRequest: URLRequest) -> AnyPublisher<Result<[Product], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
