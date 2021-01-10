//
//  AdoptionLoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionLoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @State var isSaveDisabled = true
    @State private var actionState: Int? = 0
    @Binding var isAdoptionFailed: Bool
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    @State var isTryingToAdopt: Bool = false
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
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
                
                HStack {
                    Text(Localization.loginNoAccount)
                        .font(.subheadline)
                        .foregroundColor(.init("color_font_primary"))
                    
                    NavigationLink(destination: SignupView())
                    {
                        Text(Localization.signupBtn)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    isTryingToAdopt.toggle()
                    loginAndPay()
                    
                }, label: {
                    Text(Localization.loginPayBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(isSaveDisabled)
                .frame(width: 160, height: 40, alignment: .center)
                .background(isSaveDisabled ? Color.gray : Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.loginAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
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
        .onReceive(inputValidationViewModel.loginValidation) { validation in
            isSaveDisabled = !validation.isSuccess
        }
    }
}

extension AdoptionLoginView {
    
    func loginAndPay() {
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
                    message = Localization.adoptionLoginPurchaseError
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
