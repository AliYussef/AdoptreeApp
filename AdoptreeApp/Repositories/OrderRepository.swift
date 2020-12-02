//
//  OrderRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol OrderRepositoryProtocol {
    func createOrder(using urlRequest: URLRequest) -> AnyPublisher<OrderResponse, Error>
}

class OrderRepository: OrderRepositoryProtocol {
    
    func createOrder(using urlRequest: URLRequest) -> AnyPublisher<OrderResponse, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
}
