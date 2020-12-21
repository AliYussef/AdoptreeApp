//
//  SuccessfullAdoptionView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SuccessfullAdoptionView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var actionState: Int? = 0
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Thank you for your adoption")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.init("color_font_primary"))
                
                Text("With your contribution CO2 emissions can be reduced and wildlife and biodiversity will further thrive.")
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    .font(.subheadline)
                    .foregroundColor(.init("color_font_primary"))
                
                Image("happy_tree")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                
                Spacer()
                
                NavigationLink(destination: HomeView(treeViewModel: ViewModelFactory().makeTreeViewModel(), timelineViewModel: ViewModelFactory().makeTimelineViewModel())
                                .navigationBarTitle("HOME", displayMode: .inline)
                                .navigationBarBackButtonHidden(true)
                               , tag: 1, selection: $actionState) {
                    EmptyView()
                }
                
                Button(action: {
                    if userViewModel.isGuest {
                        userViewModel.isGuest.toggle()
                        //userViewModel.accessToken = userViewModel.tempAccessToken
                        userViewModel.isAuthenticated = true //this should be removed once authentication is set up
                    } else if userViewModel.isAuthenticated {
                        actionState = 1
                    } else {
                        //userViewModel.accessToken = userViewModel.tempAccessToken
                        userViewModel.isAuthenticated = true //this should be removed once authentication is set up
                    }
                    
                }, label: {
                    Text("Follow your tree")
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

struct SuccessfullAdoptionView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfullAdoptionView()
    }
}
