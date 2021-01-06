//
//  GuestProfileView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 03/12/2020.
//

import SwiftUI

struct GuestProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        
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
            
            Text("HELLO YOU!")
                .font(.title2)
                .foregroundColor(.init("color_font_primary"))
                .padding(.bottom, 50)
            
            
            List {
                
                Button(action: {
                    self.userViewModel.isGuest.toggle()
                }, label: {
                    Text("Log in")
                })
                
            }
            .listStyle(PlainListStyle())
            
        }
    }
}

