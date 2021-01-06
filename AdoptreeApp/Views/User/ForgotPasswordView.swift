//
//  ForgotPasswordView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @State var isSaveDisabled = true
    @State private var showingAlert = false
    @State private var message = ""
    @State var isTryingToChangePassword: Bool = false
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                if userViewModel.forgetPasswordToken.isEmpty {
                    RequestPasswordChangeView(inputValidationViewModel: inputValidationViewModel)
                } else {
                    
                    SecureField("Password", text: $inputValidationViewModel.password)
                        .validation(inputValidationViewModel.passwordValidation)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    SecureField("Confirm password", text: $inputValidationViewModel.confirmPassword)
                        .validation(inputValidationViewModel.confirmPasswordValidation)
                        .validation(inputValidationViewModel.confirmPasswordMatchingValidation)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        isTryingToChangePassword.toggle()
                        userViewModel.resetPassword(resetPasswordBody: ResetPasswordBody(user_id: nil, token: self.userViewModel.forgetPasswordToken, created_at: nil, valid_until: nil, password: inputValidationViewModel.password, validate_password: inputValidationViewModel.confirmPassword)) {result in
                            switch (result) {
                                case .failure(_):
                                    message = "Somthing went wrong. Please try again!"
                                    showingAlert.toggle()
                                case .success(_):
                                    message = "Password has been reset"
                                    showingAlert.toggle()
                                    self.presentationMode.wrappedValue.dismiss()
                            }
                            isTryingToChangePassword.toggle()
                        }
                    }, label: {
                        Text("Reset my password")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .disabled(isSaveDisabled)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50, alignment: .center)
                    .background(isSaveDisabled ? Color.gray : Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Reset password"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
                    }
                    
                    if isTryingToChangePassword {
                        withAnimation(.linear) {
                            ZStack {
                                Image("tree")
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.0)
                                    .background(Blur(style: .systemUltraThinMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                
                                ProgressView("Changing password...")
                            }
                        }
                    }
                }
            }
            .onReceive(inputValidationViewModel.resetPasswordValidation) { validation in
                isSaveDisabled = !validation.isSuccess
            }
        }
        .navigationBarTitle("Forgot password", displayMode: .inline)
        
    }
}

struct RequestPasswordChangeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel: InputValidationViewModel
    @State var isSaveDisabled = true
    @State private var showingAlert = false
    @State private var message = ""
    @State var isTryingToChangePassword: Bool = false
    
    var body: some View {
        TextField("Email Address", text: $inputValidationViewModel.email)
            .validation(inputValidationViewModel.emailEmptyValidation)
            .validation(inputValidationViewModel.emailValidation)
            .padding()
            .background(Color.init("color_textfield"))
            .cornerRadius(8.0)
            .keyboardType(.default)
            .autocapitalization(.none)
            .padding()
        
        TextField("Username", text: $inputValidationViewModel.username)
            .validation(inputValidationViewModel.usernameValidation)
            .padding()
            .background(Color.init("color_textfield"))
            .cornerRadius(8.0)
            .keyboardType(.default)
            .autocapitalization(.none)
            .padding()
        
        Button(action: {
            isTryingToChangePassword.toggle()
            userViewModel.forgetPassword(forgetPasswordBody: ForgetPasswordBody(username: inputValidationViewModel.username, email: inputValidationViewModel.username)) { result in
                switch (result) {
                    case .failure(_):
                        message = "An error has occurred. Please check your username and email!"
                        showingAlert.toggle()
                    case .success(_):
                        break
                }
                isTryingToChangePassword.toggle()
            }
        }, label: {
            Text("Request password change")
                .font(.subheadline)
                .foregroundColor(.white)
        })
        .disabled(isSaveDisabled)
        .frame(width: UIScreen.main.bounds.width * 0.6, height: 50, alignment: .center)
        .background(isSaveDisabled ? Color.gray : Color.init("color_primary_accent"))
        .cornerRadius(10.0)
        .padding()
        .onReceive(inputValidationViewModel.requestResetPasswordValidation) { validation in
            isSaveDisabled = !validation.isSuccess
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Reset password"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
        }
        
        if isTryingToChangePassword {
            withAnimation(.linear) {
                ZStack {
                    Image("tree")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.0)
                        .background(Blur(style: .systemUltraThinMaterial))
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView("Request password change...")
                }
            }
        }
    }
}

