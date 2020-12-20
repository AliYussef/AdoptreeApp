//
//  ContentView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ContentView: View {
    private let viewModelFactory: ViewModelFactory
    @ObservedObject var treeViewModel: TreeViewModel
    @ObservedObject var timelineViewModel: TimelineViewModel
    @ObservedObject var newsViewModel: NewsViewModel
    
    init() {
        viewModelFactory = ViewModelFactory()
        treeViewModel = viewModelFactory.makeTreeViewModel()
        timelineViewModel = viewModelFactory.makeTimelineViewModel()
        newsViewModel = viewModelFactory.makeNewsViewModel()
    }
    
    var body: some View {
        
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.bottom)
            
            TabView {
                NavigationView {
                    HomeView(treeViewModel: treeViewModel, timelineViewModel: timelineViewModel)
                        .navigationBarTitle("HOME", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                NavigationView {
                    TimelineView(timelineViewModel: timelineViewModel, treeViewModel: treeViewModel)
                        .navigationBarTitle("TIMELINE", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "timeline.selection")
                    Text("Timeline")
                }
                
                NavigationView {
                    NewsView(newsViewModel: newsViewModel)
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
                if treeViewModel.trees.isEmpty {
                    treeViewModel.getAdoptedTrees(of: 1) { result in
                        switch (result) {
                            case .failure(let error):
                                print(error)
                            case .success(let success):
                                //print("success")
                                treeViewModel.trees = success
                                for _ in treeViewModel.trees.indices {
                                    treeViewModel.isExpanded.append(false)
                                }
                                //timelineViewModel.getTimeLineData(using: 1)
                                if timelineViewModel.telemetries.isEmpty {
                                    treeViewModel.trees.forEach({ tree in
                                        if let treeId = tree.assignedTree?.tree_id {
                                            timelineViewModel.getTimeLineData(using: treeId)
                                        }
                                    })
                                }
                                
                                if timelineViewModel.datesFilter.isEmpty {
                                    timelineViewModel.createTimelineTreeObject(trees: treeViewModel.trees)
                                    timelineViewModel.createTimelineDateFilter(trees: treeViewModel.trees)
                                }
                                
                        }
                    }
                }
            }
            //.accentColor(.init("color_primary_accent"))
            
        }
    }
}

