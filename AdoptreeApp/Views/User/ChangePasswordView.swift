//
//  ChangePasswordView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct ChangePasswordView: View {
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
                        resetPassword()
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
    }
}

extension ChangePasswordView {
    
    func resetPassword() {
        userViewModel.resetPassword(resetPasswordBody: ResetPasswordBody(user_id: nil, token: inputValidationViewModel.token, created_at: nil, valid_until: nil, password: inputValidationViewModel.password, validate_password: inputValidationViewModel.confirmPassword)) {result in
            switch (result) {
                case .failure(_):
                    message = Localization.errorOccurred
                    showingAlert.toggle()
                case .success(_):
                    message = Localization.successfulPasswordReset
                    showingAlert.toggle()
            }
            isTryingToChangePassword.toggle()
        }
    }
    
}
