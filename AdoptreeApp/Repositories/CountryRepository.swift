//
//  CountryRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 22/12/2020.
//

import Foundation
import Combine

protocol CountryRepositoryProtocol {
    func getCountries(using urlRequest: URLRequest) -> AnyPublisher<Result<[Country], RequestError>, Never>
}

class CountryRepository: CountryRepositoryProtocol {
    
    func getCountries(using urlRequest: URLRequest) -> AnyPublisher<Result<[Country], RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
