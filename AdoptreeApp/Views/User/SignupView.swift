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
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    @State var isTryingToAdopt: Bool = false
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    Section(header: HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.init("color_primary_accent"))
                        Text(Localization.signupTitle)
                            .foregroundColor(.init("color_font_primary"))
                    }, content: {
                        TextField(Localization.firstNameField, text: $inputValidationViewModel.firstName)
                            .validation(inputValidationViewModel.firstNameValidation)
                        
                        TextField(Localization.lastNameField, text: $inputValidationViewModel.lastName)
                            .validation(inputValidationViewModel.lastNameValidation)
                        
                        TextField(Localization.emailField, text: $inputValidationViewModel.email)
                            .validation(inputValidationViewModel.emailValidation)
                            .validation(inputValidationViewModel.emailEmptyValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        TextField(Localization.usernameField, text: $inputValidationViewModel.username)
                            .validation(inputValidationViewModel.usernameValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        SecureField(Localization.passwordField, text: $inputValidationViewModel.password)
                            .validation(inputValidationViewModel.passwordValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        SecureField(Localization.confirmPasswordField, text: $inputValidationViewModel.confirmPassword)
                            .validation(inputValidationViewModel.confirmPasswordValidation)
                            .validation(inputValidationViewModel.confirmPasswordMatchingValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                    })
                }
                .onReceive(inputValidationViewModel.allValidation) { validation in
                    isSaveDisabled = !validation.isSuccess
                }
                .background(Color.init("color_background"))
                .padding(.top, 50)
                
                Button(action: {
                    isTryingToAdopt.toggle()
                    if userViewModel.userShared.id == nil {
                        signupAndPay()
                    } else {
                        if let userId = userViewModel.userShared.id {
                            createOrders(for: userId)
                        }
                    }
                }, label: {
                    Text(Localization.signupPayBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(isSaveDisabled)
                .frame(width: 160, height: 40, alignment: .center)
                .background(isSaveDisabled ? Color.gray : Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.signupAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                }
                
                if isTryingToAdopt {
                    withAnimation(.linear) {
                        ZStack {
                            Image("tree")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.0)
                                .background(Blur(style: .systemUltraThinMaterial))
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView(Localization.loginAdoptingProgress)
                        }
                    }
                }
            }
        }
    }
}

extension SignupView {
    
    func signupAndPay() {
        let user = User(id: nil, firstname: inputValidationViewModel.firstName, lastname: inputValidationViewModel.lastName, username: inputValidationViewModel.username, email: inputValidationViewModel.email, password: inputValidationViewModel.password, salt: nil, forgetToken: nil, role: nil, createdAt: nil)
        
        userViewModel.registerUser(user: user) { result in
            switch (result) {
                case .failure(_):
                    message = Localization.errorOccurred
                    showingAlert.toggle()
                case .success(_):
                    login()
            }
        }
    }
    
    func login() {
        let user = UserLogin(username: inputValidationViewModel.username, password: inputValidationViewModel.password)
        
        userViewModel.login(user: user) { result in
            switch (result) {
                case .failure(_):
                    message = Localization.loginError
                    showingAlert.toggle()
                case .success(let response):
                    userViewModel.accessToken = response.accessToken
                    userViewModel.refreshToken = response.refreshToken
                    getUser()
            }
        }
    }
    
    func getUser() {
        userViewModel.getLoggedinUser() { result in
            switch (result) {
                case .failure(_):
                    message = Localization.loginError
                    showingAlert.toggle()
                case .success(let response):
                    if let userId = response.id {
                        createOrders(for: userId)
                    }
            }
        }
    }
    
    func createOrders(for userId: Int64) {
        let order = self.orderViewModel.createOrderObject(for: userId)
        self.orderViewModel.createOrder(order: order) { result in
            switch (result) {
                case .failure(_):
                    message = Localization.signupPurchaseError
                    showingAlert.toggle()
                case .success(let success):
                    if let url = URL(string: success.paymentLink) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
            }
            isTryingToAdopt.toggle()
        }
    }
}
