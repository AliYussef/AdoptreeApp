//
//  ViewRouter.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 05/12/2020.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var currentPage: String
    
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = "startingView"
        }
    }
}
