//
//  SignupView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @State var isSaveDisabled = true
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var email = ""
//    @State private var username = ""
//    @State private var password = ""
//    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    Section(header: HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.init("color_primary_accent"))
                        Text("Create an account")
                            .foregroundColor(.init("color_font_primary"))
                    }, content: {
                        TextField("First name", text: $inputValidationViewModel.firstName)
                            .validation(inputValidationViewModel.firstNameValidation)
                        
                        TextField("Last name", text: $inputValidationViewModel.lastName)
                            .validation(inputValidationViewModel.lastNameValidation)
                        
                        TextField("Email", text: $inputValidationViewModel.email)
                            .validation(inputValidationViewModel.emailValidation)
                            .validation(inputValidationViewModel.emailEmptyValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        TextField("Username", text: $inputValidationViewModel.username)
                            .validation(inputValidationViewModel.usernameValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $inputValidationViewModel.password)
                            .validation(inputValidationViewModel.passwordValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        SecureField("Confirm password", text: $inputValidationViewModel.confirmPassword)
                            .validation(inputValidationViewModel.confirmPasswordValidation)
                            .validation(inputValidationViewModel.confirmPasswordMatchingValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                    })
                }
                .onReceive(inputValidationViewModel.allValidation) { validation in
                    self.isSaveDisabled = !validation.isSuccess
                }
                .background(Color.init("color_background"))
                .padding(.top, 50)
                
                Button(action: {
                    //register here
                    let user = User(id: nil, firstname: inputValidationViewModel.firstName, lastname: inputValidationViewModel.lastName, username: inputValidationViewModel.username, email: inputValidationViewModel.email, password: inputValidationViewModel.password, forgetToken: nil, role: nil, createdAt: nil)
                    userViewModel.registerUser(user: user) { result in
                        switch (result) {
                            case .failure(_):
                                break
                            case .success(let user):
                                userViewModel.userShared = UserShared(id: user.id, firstname: user.firstname, lastname: user.lastname, username: user.username, email: user.email)
                                userViewModel.saveUserSharedObject()
                                if let userId = user.id {
                                    let order = self.orderViewModel.createOrderObject(for: userId)
                                    self.orderViewModel.createOrder(order: order) { result in
                                        switch (result) {
                                            case .failure(_):
                                                break
                                            case .success(let success):
                                                if let url = URL(string: success.paymentLink) {
                                                    if UIApplication.shared.canOpenURL(url) {
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                    }
                                                }
                                        }
                                    }
                                }
                        }
                    }
                }, label: {
                    Text("Sign up & pay")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(self.isSaveDisabled)
                .frame(width: 160, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
