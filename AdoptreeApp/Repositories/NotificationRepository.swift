//
//  NotificationRepository.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 08/12/2020.
//

import Foundation
import Combine

protocol NotificationRepositoryProtocol {
    func createNotificationDevice(using urlRequest: URLRequest) -> AnyPublisher<NotificationDevice, Error>
    func updateNotificationDevice(using urlRequest: URLRequest) -> AnyPublisher<NotificationDevice, Error>
}

class NotificationRepository: NotificationRepositoryProtocol {
    
    func createNotificationDevice(using urlRequest: URLRequest) -> AnyPublisher<NotificationDevice, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
    
    func updateNotificationDevice(using urlRequest: URLRequest) -> AnyPublisher<NotificationDevice, Error> {
        return NetworkManager.sharedNetworkManager.executeRequestWithResponseBody(using: urlRequest)
    }
}
