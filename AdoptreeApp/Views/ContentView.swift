//
//  ContentView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ContentView: View {
    // @Binding var isNavigationBarHidden: Bool
    @ObservedObject var treeViewModel: TreeViewModel
    
    var body: some View {
        
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.bottom)
            
            TabView {
                NavigationView {
                    HomeView(treeViewModel: treeViewModel)
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
            .accentColor(.init("color_primary_accent"))
            
        }
        
        
        
        
        
    }
    
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
