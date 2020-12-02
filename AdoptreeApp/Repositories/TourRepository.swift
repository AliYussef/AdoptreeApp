//
//  TourRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol TourRepositoryProtocol {
    func getTours(using urlRequest: URLRequest) -> AnyPublisher<[Tour], Error> //get
    func bookTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> //post
    func updateBookedTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> //put
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> //get
    func cancelBookedTour(using urlRequest: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> //delete
    
}

class TourRepository: TourRepositoryProtocol {
    
    func cancelBookedTour(using urlRequest: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> {
        return ApiClient.sharedApiClient.executeRequestWithoutResponseBody(using: urlRequest)
    }
    
    func getTours(using urlRequest: URLRequest) -> AnyPublisher<[Tour], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func bookTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func updateBookedTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
