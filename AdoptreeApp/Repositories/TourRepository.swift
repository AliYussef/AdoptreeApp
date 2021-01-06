//
//  TourRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol TourRepositoryProtocol {
    func getTours(using urlRequest: URLRequest) -> AnyPublisher<Result<[Tour], RequestError>, Never>
    func bookTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error>
    func updateBookedTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error>
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never>
    func cancelBookedTour(using urlRequest: URLRequest) -> AnyPublisher<Data, Error>
    
}

class TourRepository: TourRepositoryProtocol {
    
    func cancelBookedTour(using urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithoutResponseBody(using: urlRequest)
    }
    
    func getTours(using urlRequest: URLRequest) -> AnyPublisher<Result<[Tour], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func bookTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func updateBookedTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
