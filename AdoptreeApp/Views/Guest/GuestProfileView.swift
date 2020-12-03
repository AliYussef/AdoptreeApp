//
//  GuestProfileView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 03/12/2020.
//

import SwiftUI

struct GuestProfileView: View {
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
                
                Text("HELLO YOU!")
                    .font(.title2)
                    .foregroundColor(.init("color_font_primary"))
                    .padding(.bottom, 50)
                
                
                List {
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Log in")
                        })
                    
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text("Adopt now")
                        })
                }
                .listStyle(PlainListStyle())
                
            }
        }
    }
}

struct GuestProfileView_Previews: PreviewProvider {
    static var previews: some View {
        GuestProfileView()
    }
}
