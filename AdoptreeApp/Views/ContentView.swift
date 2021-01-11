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
    @State private var showingAlertConfirm = false
    
    var body: some View {
        
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.bottom)
            
            TabView {
                NavigationView {
                    HomeView()
                        .navigationBarTitle(Localization.homeTitle, displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(Localization.homeTitleText)
                }
                
                NavigationView {
                    TimelineView()
                        .navigationBarTitle(Localization.timelineTitle, displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "timeline.selection")
                    Text(Localization.timelineTitleText)
                }
                
                NavigationView {
                    NewsView()
                        .navigationBarTitle(Localization.newsTitle, displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text(Localization.newsTitleText)
                }
                
                NavigationView {
                    ProfileView()
                        .navigationBarTitle(Localization.profileTitle, displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(Localization.profileTitleText)
                }
                
                NavigationView {
                    SettingView()
                        .navigationBarTitle(Localization.settingsTitle, displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text(Localization.settingsTitleText)
                }
            }
            .alert(isPresented: $showingAlertConfirm) {
                Alert(title: Text(Localization.contentAlertTitle), message: Text(Localization.contentAlertMessage), primaryButton: .default(Text(Localization.tryAgianBtn)){
                    fetchViewsData()
                },secondaryButton: .cancel(Text(Localization.noBtn)))
            }
            .onAppear {
                fetchViewsData()
            }
        }
    }
}

extension ContentView {
    func fetchViewsData() {
        if userViewModel.isAuthenticated && treeViewModel.trees.isEmpty {
            treeViewModel.getAdoptedTrees() { result in
                switch (result) {
                    case .failure(_):
                        self.showingAlertConfirm.toggle()
                        break
                    case .success(_):
                        if timelineViewModel.telemetries.isEmpty {
                            treeViewModel.trees.forEach({ tree in
                                if let treeId = tree.assignedTree?.tree_id {
                                    timelineViewModel.getTimeLineData(using: treeId)
                                }
                            })
                        }
                        treeViewModel.getForestsAndCountries()
                }
            }
            
            if newsViewModel.contents.isEmpty || newsViewModel.tours.isEmpty {
                newsViewModel.getNewsViewData()
                
            }
        }
        
        if !userViewModel.isAuthenticated {
            newsViewModel.getContent() {_ in}
        }
    }
}
