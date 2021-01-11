//
//  StartingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct StartingView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @EnvironmentObject var newsViewModel: NewsViewModel
    
    var body: some View {
        
        if userViewModel.isAuthenticated || userViewModel.isGuest {
            ContentView()
                .transition(.move(edge: .trailing))
        } 
        else {
            
            LoginView()
                .onAppear {
                    treeViewModel.clearDataForLogout()
                    timelineViewModel.clearDataForLogout()
                    newsViewModel.clearDataForLogout()
                }
        }
    }
}
