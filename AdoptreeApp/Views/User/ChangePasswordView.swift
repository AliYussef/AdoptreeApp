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
    @State private var message = ""
    @State var isTryingToChangePassword: Bool = false
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                SecureField("New password", text: $inputValidationViewModel.password)
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
                    if let userId = userViewModel.userShared.id {
                        if let firstName = userViewModel.userShared.firstname {
                            if let lastName = userViewModel.userShared.lastname {
                                if let username = userViewModel.userShared.username {
                                    let user = User(id: userId, firstname: firstName, lastname: lastName, username: username, email: inputValidationViewModel.email, password: inputValidationViewModel.password, salt: nil, forgetToken: nil, role: nil, createdAt: nil)
                                    
                                    userViewModel.updateUserAccount(user: user) { result in
                                        switch (result) {
                                            case .failure(_):
                                                message = "An error occurred. Please check your password!"
                                                showingAlert.toggle()
                                            case .success(_):
                                                message = "Password has been changed"
                                                showingAlert.toggle()
                                        }
                                        isTryingToChangePassword.toggle()
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Confirm")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(isConfirmDisabled)
                .frame(width: 180, height: 40, alignment: .center)
                .background(isConfirmDisabled ? Color.gray : Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Password reset"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
                }
            }
            .onReceive(inputValidationViewModel.resetPasswordValidation) { validation in
                isConfirmDisabled = !validation.isSuccess
            }
            
            if isTryingToChangePassword {
                ProgressView("Changing password...")
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
