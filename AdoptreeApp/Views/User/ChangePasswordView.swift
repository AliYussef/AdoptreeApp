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
    @State var isConfirmDisabled = true
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    @State var isTryingToChangePassword: Bool = false
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                SecureField(Localization.newPasswordField, text: $inputValidationViewModel.password)
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
                    if let userId = userViewModel.userShared.id {
                        if let firstName = userViewModel.userShared.firstname {
                            if let lastName = userViewModel.userShared.lastname {
                                if let username = userViewModel.userShared.username {
                                    let user = User(id: userId, firstname: firstName, lastname: lastName, username: username, email: inputValidationViewModel.email, password: inputValidationViewModel.password, salt: nil, forgetToken: nil, role: nil, createdAt: nil)
                                    
                                    userViewModel.updateUserAccount(user: user) { result in
                                        switch (result) {
                                            case .failure(_):
                                                message = Localization.errorOccurred
                                                showingAlert.toggle()
                                            case .success(_):
                                                message = Localization.successfulPasswordChange
                                                showingAlert.toggle()
                                        }
                                        isTryingToChangePassword.toggle()
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Text(Localization.confirmBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(isConfirmDisabled)
                .frame(width: 180, height: 40, alignment: .center)
                .background(isConfirmDisabled ? Color.gray : Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.resetPasswordAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                }
            }
            .onReceive(inputValidationViewModel.resetPasswordValidation) { validation in
                isConfirmDisabled = !validation.isSuccess
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
}
