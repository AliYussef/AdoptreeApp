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
    @State private var message = LocalizedStringKey("")
    @State var isTryingToLogin: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text(Localization.loginTitle)
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    TextField(Localization.usernameField, text: $inputValidationViewModel.username)
                        .validation(inputValidationViewModel.usernameValidation)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    SecureField(Localization.passwordField, text: $inputValidationViewModel.password)
                        .validation(inputValidationViewModel.passwordValidation)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        isTryingToLogin.toggle()
                        login()
                    }, label: {
                        Text(Localization.loginBtn)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .disabled(isLoginDisabled)
                    .frame(width: 180, height: 40, alignment: .center)
                    .background(isLoginDisabled ? Color.gray : Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(Localization.loginAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                    }
                    
                    HStack {
                        Text(Localization.loginNoAccountYet)
                            .foregroundColor(.init("color_font_primary"))
                        
                        NavigationLink(destination: TreeSelectionView())
                        {
                            Text(Localization.loginAdoptNow)
                                .bold()
                                .foregroundColor(.init("color_font_primary"))
                        }
                        
                    }
                    .padding()
                    
                    NavigationLink(destination: ForgotPasswordView())
                    {
                        Text(Localization.loginForgotPassword)
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
                        Text(Localization.loginNotNow)
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
                            
                            ProgressView(Localization.loginProgress)
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

extension LoginView {
    func login() {
        let user = UserLogin(username:inputValidationViewModel.username, password:inputValidationViewModel.password)
        userViewModel.login(user: user) { result in
            switch (result) {
                case .failure(_):
                    message = Localization.loginError
                    showingAlert.toggle()
                case .success(let response):
                    userViewModel.accessToken = response.accessToken
                    userViewModel.refreshToken = response.refreshToken
                    if userViewModel.accessToken != nil {
                        userViewModel.isAuthenticated = true
                    }
                    userViewModel.getLoggedinUser() {_ in}
            }
            
            isTryingToLogin.toggle()
        }
    }
}
