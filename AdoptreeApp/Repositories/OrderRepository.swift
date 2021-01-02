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
    func getOrderById(using urlRequest: URLRequest) -> AnyPublisher<Order, Error>
}

class OrderRepository: OrderRepositoryProtocol {
    
    func createOrder(using urlRequest: URLRequest) -> AnyPublisher<OrderResponse, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getOrderById(using urlRequest: URLRequest) -> AnyPublisher<Order, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
}
