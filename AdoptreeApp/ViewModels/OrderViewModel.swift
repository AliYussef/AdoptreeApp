//
//  OrderViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class OrderViewModel: ObservableObject {
    @Published var order: OrderResponse?
    private var cancellables = Set<AnyCancellable>()
    private let orderRepository: OrderRepositoryProtocol
    
    init(orderRepository: OrderRepositoryProtocol) {
        self.orderRepository = orderRepository
    }
}

extension OrderViewModel {
    
    func createOrder(order: Order, completion: @escaping (Result<OrderResponse, RequestError>) -> Void) {
        
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .order, using: .post, withParams: order)
            
            orderRepository.createOrder(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                    
                }, receiveValue: {result in
                    completion(.success(result))
                    self.order = result
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    
}
