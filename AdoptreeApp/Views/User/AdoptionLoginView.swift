//
//  AdoptionLoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionLoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.init("color_textfield"))
                    .cornerRadius(8.0)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.init("color_textfield"))
                    .cornerRadius(8.0)
                    .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    .autocapitalization(.none)
                    .padding()
                
                HStack {
                    Text("No account yet?")
                        .font(.subheadline)
                        .foregroundColor(.init("color_font_primary"))
                    
                    NavigationLink(destination: SignupView())
                    {
                        Text("Sign up")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    }
                }
                .padding()
                
                Spacer()
                
                //                NavigationLink(destination: HomeView())
                //                {
                //                    Text("Log in & Pay")
                //                        .bold()
                //                        .foregroundColor(.white)
                //                }
                //                .frame(width: 180, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //                .background(Color.init("color_primary_accesnt"))
                //                .cornerRadius(10.0)
                //                .padding()
                
                
            }
        }
    }
}

struct AdoptionLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptionLoginView()
    }
}
