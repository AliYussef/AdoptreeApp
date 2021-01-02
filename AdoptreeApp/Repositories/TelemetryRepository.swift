//
//  TelemetryRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

protocol TelemetryRepositoryProtocol {
    func getTelemetryByTree(using urlRequest: URLRequest) -> AnyPublisher<Result<Telemetry, RequestError>, Never>
}

class TelemetryRepository: TelemetryRepositoryProtocol {
    
    func getTelemetryByTree(using urlRequest: URLRequest) -> AnyPublisher<Result<Telemetry, RequestError>, Never> {
        return NetworkManager.sharedNetworkManager.executeRequestsWithResponseBody(using: urlRequest)
    }
    
}
