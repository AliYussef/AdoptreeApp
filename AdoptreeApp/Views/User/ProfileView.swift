//
//  ProfileView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Circle()
                    .frame(width: 150, height: 150, alignment: .center)
                    .foregroundColor(.init("color_textfield"))
                    .overlay(
                        Image("profile")
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                    )
                    .padding()
                
                Text("YOUR NAME")
                    .font(.title2)
                    .foregroundColor(.init("color_font_primary"))
                    .padding(.bottom, 50)
                
                
                List {
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Your contract")
                        })
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Change email address")
                        })
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Chnage password")
                        })
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Delete your account")
                                .foregroundColor(.red)
                        })
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Log out")
                        })
                }
                .listStyle(PlainListStyle())
                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
