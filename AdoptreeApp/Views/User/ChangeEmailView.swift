//
//  ChangeEmailView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct ChangeEmailView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @State var isConfirmDisabled = true
    @State private var showingAlert = false
    @State private var message = ""
    @State var isTryingToChangeEmail: Bool = false
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("New email address", text: $inputValidationViewModel.email)
                    .validation(inputValidationViewModel.emailValidation)
                    .validation(inputValidationViewModel.emailEmptyValidation)
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
                    isTryingToChangeEmail.toggle()
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
                                                message = "Email has been changed"
                                                showingAlert.toggle()
                                        }
                                        isTryingToChangeEmail.toggle()
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
                    Alert(title: Text("Email reset"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
                }
            }
            .onReceive(inputValidationViewModel.changeEmailValidation) { validation in
                isConfirmDisabled = !validation.isSuccess
            }
            
            if isTryingToChangeEmail {
                ProgressView("Changing email...")
            }
        }
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
    }
}
