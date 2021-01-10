//
//  SuccessfullAdoptionView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SuccessfulAdoptionView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @State private var actionState: Int? = 0
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text(Localization.successfulAdoptionTitle)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.init("color_font_primary"))
                
                Text(Localization.successfulAdoptionText)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    .font(.subheadline)
                    .foregroundColor(.init("color_font_primary"))
                
                Image("happy_tree")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                
                Spacer()
                
                NavigationLink(destination: HomeView()
                                .navigationBarTitle(Localization.homeTitle, displayMode: .inline)
                                .navigationBarBackButtonHidden(true)
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
                                    }
                                }
                               , tag: 1, selection: $actionState) {
                    EmptyView()
                }
                
                Button(action: {
                    if userViewModel.isGuest {
                        userViewModel.isGuest.toggle()
                        if userViewModel.accessToken != nil {
                            userViewModel.isAuthenticated = true
                        }
                    } else if userViewModel.isAuthenticated {
                        actionState = 1
                    } else {
                        if userViewModel.accessToken != nil {
                            userViewModel.isAuthenticated = true
                        }
                    }
                    
                }, label: {
                    Text(Localization.followTreeBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
        }
        .navigationBarHidden(true)
    }
}
