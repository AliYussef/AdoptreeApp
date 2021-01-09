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
    @State private var message = LocalizedStringKey("")
    @State var isTryingToChangePassword: Bool = false
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                if !userViewModel.isforgetPasswordTokenSent {
                    RequestPasswordChangeView(inputValidationViewModel: inputValidationViewModel)
                } else {
                    
                    Text(Localization.forgotPasswordNote)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                    
                    TextField("Reset token", text: $inputValidationViewModel.token)
                        .validation(inputValidationViewModel.tokenValidation)
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
                    
                    SecureField(Localization.confirmPasswordField, text: $inputValidationViewModel.confirmPassword)
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
                        userViewModel.resetPassword(resetPasswordBody: ResetPasswordBody(user_id: nil, token: inputValidationViewModel.token, created_at: nil, valid_until: nil, password: inputValidationViewModel.password, validate_password: inputValidationViewModel.confirmPassword)) {result in
                            switch (result) {
                                case .failure(_):
                                    message = Localization.errorOccurred
                                    showingAlert.toggle()
                                case .success(_):
                                    message = Localization.successfulPasswordReset
                                    showingAlert.toggle()
                                    self.presentationMode.wrappedValue.dismiss()
                            }
                            isTryingToChangePassword.toggle()
                        }
                    }, label: {
                        Text(Localization.resetPasswordBtn)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .disabled(isSaveDisabled)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50, alignment: .center)
                    .background(isSaveDisabled ? Color.gray : Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(Localization.resetPasswordAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
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
                                
                                ProgressView(Localization.resetPasswordProgress)
                            }
                        }
                    }
                }
            }
            .onReceive(inputValidationViewModel.resetPasswordValidation) { validation in
                isSaveDisabled = !validation.isSuccess
            }
        }
        .navigationBarTitle(Localization.forgotPasswordTitle, displayMode: .inline)
        
    }
}

struct RequestPasswordChangeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel: InputValidationViewModel
    @State var isSaveDisabled = true
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    @State var isTryingToChangePassword: Bool = false
    
    var body: some View {
        TextField(Localization.emailField, text: $inputValidationViewModel.email)
            .validation(inputValidationViewModel.emailEmptyValidation)
            .validation(inputValidationViewModel.emailValidation)
            .padding()
            .background(Color.init("color_textfield"))
            .cornerRadius(8.0)
            .keyboardType(.default)
            .autocapitalization(.none)
            .padding()
        
        TextField(Localization.usernameField, text: $inputValidationViewModel.username)
            .validation(inputValidationViewModel.usernameValidation)
            .padding()
            .background(Color.init("color_textfield"))
            .cornerRadius(8.0)
            .keyboardType(.default)
            .autocapitalization(.none)
            .padding()
        
        Button(action: {
            isTryingToChangePassword.toggle()
            userViewModel.forgetPassword(forgetPasswordBody: ForgetPasswordBody(username: inputValidationViewModel.username, email: inputValidationViewModel.email)) { result in
                switch (result) {
                    case .failure(_):
                        message = Localization.requestPasswordResetError
                        showingAlert.toggle()
                    case .success(_):
                        break
                }
                isTryingToChangePassword.toggle()
            }
        }, label: {
            Text(Localization.requestPasswordChangeBtn)
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
            Alert(title: Text(Localization.resetPasswordAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
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
                    
                    ProgressView(Localization.requestPasswordProgress)
                }
            }
        }
    }
}

