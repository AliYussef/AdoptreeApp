//
//  ViewModelFactory.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

class ViewModelFactory {
    
    private let userRepository = UserRepository()
    private let treeRepository = TreeRepository()
    private let telemetryRepository = TelemetryRepository()
    private let forestRepository = ForestRepository()
    private let contentRepository = ContentRepository()
    private let orderRepository = OrderRepository()
    private let productRepository = ProductRepository()
    private let categoryRepository = CategoryRepository()
    private let notificationRepository = NotificationRepository()
    private let tourRepository = TourRepository()
}

extension ViewModelFactory {
    
//    func makeUserViewModel() -> UserViewModel {
//        return UserViewModel(userRepository: userRepository)
//    }
    
    func makeTreeViewModel() -> TreeViewModel {
        return TreeViewModel(treeRepository: treeRepository, userRepository: userRepository, contentRepository: contentRepository, forestRepository: forestRepository)
    }
    
    func makeTimelineViewModel() -> TimelineViewModel {
        return TimelineViewModel(telemetryRepository: telemetryRepository, treeRepository: treeRepository)
    }
    
    func makeOrderViewModel() -> OrderViewModel {
        return OrderViewModel(orderRepository: orderRepository, productRepository: productRepository, categoryRepository: categoryRepository)
    }
    
    func makeNewsViewModel() -> NewsViewModel {
        return NewsViewModel(contentRepository: contentRepository, tourRepository: tourRepository, userRepository: userRepository)
    }
//    func makeNotificationViewModel() -> NotificationViewModel {
//        return NotificationViewModel(notificationRepository: notificationRepository)
//    }
}
