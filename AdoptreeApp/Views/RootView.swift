//
//  RootView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 05/12/2020.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        
        if viewRouter.currentPage == "onboardingView" {
            OnboardingView()
        } else if viewRouter.currentPage == "startingView" {
            StartingView()
        }
    }
}
