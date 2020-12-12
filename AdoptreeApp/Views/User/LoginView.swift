//
//  LoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username = ""
    @State private var password = ""
    @Binding var isGuest: Bool
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Sign In to monitor your adopted tree")
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .multilineTextAlignment(.center)
                        .padding()
                    
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
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            self.userViewModel.isAuthenticated.toggle()
                        }
                        
                    }, label: {
                        Text("Log in")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .frame(width: 180, height: 40, alignment: .center)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    
                    HStack {
                        Text("Haven’t adopted a tree yet?")
                            .foregroundColor(.init("color_font_primary"))
                        
                        NavigationLink(destination: TreeSelectionView())
                        {
                            Text("Adopt Now!")
                                .bold()
                                .foregroundColor(.init("color_font_primary"))
                        }
                        
                    }
                    .padding()
                    
                    NavigationLink(destination: ForgotPasswordView())
                    {
                        Text("Forgot password?")
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            self.isGuest.toggle()
                        }
                        
                    }, label: {
                        Text("Not now, maybe later")
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    })
                    .padding()
                    
                }
                .navigationBarBackButtonHidden(true)
                
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
    }
}
