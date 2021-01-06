//
//  ContentView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @EnvironmentObject var newsViewModel: NewsViewModel

    var body: some View {
        
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.bottom)
            
            TabView {
                NavigationView {
                    HomeView()
                        .navigationBarTitle("HOME", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                NavigationView {
                    TimelineView()
                        .navigationBarTitle("TIMELINE", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "timeline.selection")
                    Text("Timeline")
                }
                
                NavigationView {
                    NewsView()
                        .navigationBarTitle("NEWS", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("News")
                }
                
                NavigationView {
                    ProfileView()
                        .navigationBarTitle("PROFILE", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                
                NavigationView {
                    SettingView()
                        .navigationBarTitle("SETTINGS", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .onAppear {
                if userViewModel.isAuthenticated && treeViewModel.trees.isEmpty {
                        treeViewModel.getAdoptedTrees() { result in
                            switch (result) {
                                case .failure(_):
                                    break
                                case .success(_):
                                    if timelineViewModel.telemetries.isEmpty {
                                        treeViewModel.trees.forEach({ tree in
                                            if let treeId = tree.assignedTree?.tree_id {
                                                timelineViewModel.getTimeLineData(using: treeId)
                                            }
                                        })
                                    }
                            }
                        }
                    
                    if newsViewModel.contents.isEmpty {
                        newsViewModel.getNewsViewData()
                    }
                }
                
                if !userViewModel.isAuthenticated {
                    newsViewModel.getContent() {_ in}
                }
            }
        }
    }
}

