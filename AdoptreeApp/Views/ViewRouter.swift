//
//  ViewRouter.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 05/12/2020.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var currentPage: String
    // pass user model view here
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            
//            if UserViewModel.shared.isAuthenticated {
//                currentPage = "contentView"
//            } else {
//                currentPage = "startingView"
//            }
            currentPage = "startingView"
        }
    }
}
