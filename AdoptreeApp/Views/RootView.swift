//
//  RootView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 05/12/2020.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewRouter: ViewRouter
   // @ObservedObject var treeViewModel: TreeViewModel
    
    var body: some View {
        
        if viewRouter.currentPage == "onboardingView" {
            OnboardingView()
        } else if viewRouter.currentPage == "contentView" {
            ContentView()
        } else if viewRouter.currentPage == "startingView" {
            StartingView()
        }
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
