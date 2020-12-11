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
    func bookTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> //post
    func updateBookedTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> //put
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never> //get
    func cancelBookedTour(using urlRequest: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> //delete
    
}

class TourRepository: TourRepositoryProtocol {
    
    func cancelBookedTour(using urlRequest: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> {
        return ApiClient.sharedApiClient.executeRequestWithoutResponseBody(using: urlRequest)
    }
    
    func getTours(using urlRequest: URLRequest) -> AnyPublisher<Result<[Tour], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
    func bookTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func updateBookedTour(using urlRequest: URLRequest) -> AnyPublisher<BookedTour, Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func getBookedToursByUser(using urlRequest: URLRequest) -> AnyPublisher<Result<[BookedTour], RequestError>, Never> {
        return ApiClient.sharedApiClient.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
