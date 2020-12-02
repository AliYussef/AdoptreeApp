//
//  TelemetryRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol TelemetryRepositoryProtocol {
    func getTelemetryByTree(using urlRequest: URLRequest) -> AnyPublisher<[Telemetry], Error>
}

class TelemetryRepository: TelemetryRepositoryProtocol {
    
    func getTelemetryByTree(using urlRequest: URLRequest) -> AnyPublisher<[Telemetry], Error> {
        return ApiClient.sharedApiClient.executeRequestWithResponseBody(using: urlRequest)
    }
    
}
