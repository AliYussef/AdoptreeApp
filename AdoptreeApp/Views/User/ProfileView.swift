//
//  ProfileView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var treeViewModel: TreeViewModel
    
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
                   
                    Text("\(userViewModel.userShared.firstname ?? "YOUR") \(userViewModel.userShared.lastname ?? "NAME")")
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 50)
                    
                    List {
                        NavigationLink(
                            destination: ContractView(treeViewModel: treeViewModel),
                            label: {
                                Text("Your contract")
                            })
                        
                        NavigationLink(
                            destination: ChangeEmailView(),
                            label: {
                                Text("Change email address")
                            })
                        
                        NavigationLink(
                            destination: ChangePasswordView(),
                            label: {
                                Text("Chnage password")
                            })
                        
                        NavigationLink(
                            destination: DeleteAccountView(treeViewModel: treeViewModel),
                            label: {
                                Text("Delete your account")
                                    .foregroundColor(.red)
                            })
                        
                        Button(action: {
                            // self.userViewModel.logout()
                            self.userViewModel.isAuthenticated = false // this will removed later
                        }, label: {
                            Text("Log out")
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

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
