//
//  ProfileView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var newsViewModel: NewsViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if userViewModel.isAuthenticated {
                    Circle()
                        .frame(width: 150, height: 150, alignment: .center)
                        .foregroundColor(.init("color_textfield"))
                        .overlay(
                            Image("profile")
                                .resizable()
                                .frame(width: 150, height: 150, alignment: .center)
                        )
                        .padding()
                    
                    Text("\(userViewModel.userShared.firstname ?? "\(Localization.profileYour)") \(userViewModel.userShared.lastname ?? "\(Localization.profileName)")")
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 50)
                    
                    List {
                        NavigationLink(
                            destination: ContractView(),
                            label: {
                                Text(Localization.profileContractTitle)
                            })
                        
                        NavigationLink(
                            destination: ChangeEmailView(),
                            label: {
                                Text(Localization.profileChangeEmail)
                            })
                        
                        NavigationLink(
                            destination: ChangePasswordView(),
                            label: {
                                Text(Localization.profileChangePassword)
                            })
                        
                        NavigationLink(
                            destination: DeleteAccountView(treeViewModel: treeViewModel),
                            label: {
                                Text(Localization.profileDeleteAccount)
                                    .foregroundColor(.red)
                            })
                        
                        Button(action: {
                            clearUserTreeData()
                            self.userViewModel.logout()
                        }, label: {
                            Text(Localization.logoutBtn)
                        })
                    }
                    .listStyle(PlainListStyle())
                } else {
                    GuestProfileView()
                }
            }
        }
    }
}

extension ProfileView {
    func clearUserTreeData() {
        treeViewModel.clearDataForLogout()
        timelineViewModel.clearDataForLogout()
        newsViewModel.clearDataForLogout()
    }
}
