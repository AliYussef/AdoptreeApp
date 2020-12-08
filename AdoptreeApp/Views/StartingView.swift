//
//  StartingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct StartingView: View {
    @State private var isAuthenticated = false
    @State private var isGuest = false
    @ObservedObject var treeViewModel: TreeViewModel
    //@State private var isAuthenticated = false
    //@EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        
        
        //        if viewRouter.currentPage == "onboardingView" {
        //            OnboardingView(treeViewModel: treeViewModel)
        //        } else if viewRouter.currentPage == "contentView" {
        //            ContentView(treeViewModel: treeViewModel)
        //        } else if viewRouter.currentPage == "loginView" {
        //            LoginView(isAuthenticated: $isAuthenticated)
        //        } else if isAuthenticated {
        //            ContentView(treeViewModel: treeViewModel)
        //                .transition(.move(edge: .trailing))
        //        }
        
        
        
        if isAuthenticated || isGuest {
            ContentView(treeViewModel: treeViewModel)
                .transition(.move(edge: .trailing))
        }
        else {
            LoginView(isAuthenticated: $isAuthenticated, isGuest: $isGuest)
        }
        
    }
}

//struct StartingView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartingView()
//    }
//}
