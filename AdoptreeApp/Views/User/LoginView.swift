//
//  LoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @State var isLoginDisabled = true
    @State private var showingAlert = false
    @State private var message = ""
    @State var isTryingToLogin: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    TextField("Username", text: $inputValidationViewModel.username)
                        .validation(inputValidationViewModel.usernameValidation)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    SecureField("Password", text: $inputValidationViewModel.password)
                        .validation(inputValidationViewModel.passwordValidation)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        isTryingToLogin.toggle()
                        withAnimation {
                            self.userViewModel.isAuthenticated.toggle()
                        }
                        
//                        let user = User(id: nil, firstname: inputValidationViewModel.firstName, lastname: inputValidationViewModel.lastName, username: inputValidationViewModel.username, email: inputValidationViewModel.email, password: inputValidationViewModel.password, forgetToken: nil, role: nil, createdAt: nil)
//                        userViewModel.login(user: user) { result in
//                            switch (result) {
//                                case .failure(_):
//                                    message = "An error occurred. Please check your username and password!"
//                                    showingAlert.toggle()
//                                case .success(let response):
//                                    //userViewModel.accessToken = response.authtoken
//                                    break
//                            }
//                            isTryingToLogin.toggle()
//                        }
                    }, label: {
                        Text("Log in")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .disabled(isLoginDisabled)
                    .frame(width: 180, height: 40, alignment: .center)
                    .background(isLoginDisabled ? Color.gray : Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Login"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
                    }
                    
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
                            self.userViewModel.isGuest.toggle()
                        }
                        
                    }, label: {
                        Text("Not now, maybe later")
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    })
                    .padding()
                    
                }
                .navigationBarBackButtonHidden(true)
                
                if isTryingToLogin {
                    withAnimation(.linear) {
                        ZStack {
                            Image("tree")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.0)
                                .background(Blur(style: .systemUltraThinMaterial))
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView("Logging in...")
                        }
                    }
                }
            }
        }
        .onReceive(inputValidationViewModel.loginValidation) { validation in
            isLoginDisabled = !validation.isSuccess
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
}

