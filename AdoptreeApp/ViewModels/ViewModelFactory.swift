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
}

extension ViewModelFactory {
    
    func makeUserViewModel() -> UserViewModel {
        return UserViewModel(userRepository: userRepository)
    }
    
    func makeTreeViewModel() -> TreeViewModel {
        return TreeViewModel(treeRepository: treeRepository, userRepository: userRepository)
    }
    
    func makeTimelineViewModel() -> TimelineViewModel {
        return TimelineViewModel(telemetryRepository: telemetryRepository, treeRepository: treeRepository)
    }
    
    func makeForestViewModel() -> ForestViewModel {
        return ForestViewModel(forestRepository: forestRepository)
    }
}
