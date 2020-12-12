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
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                if userViewModel.forgetPasswordToken.isEmpty {
                    RequestPasswordChangeView()
                } else {
                    
                    SecureField("Email Address", text: $password)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    SecureField("Email Address", text: $confirmPassword)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        // validate input here //
                        self.userViewModel.resetPassword(resetPasswordBody: ResetPasswordBody(user_id: nil, token: self.userViewModel.forgetPasswordToken, created_at: nil, valid_until: nil, password: password, validate_password: confirmPassword)) {_ in}
                        // if successull  show message//
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Reset my password")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 40, alignment: .center)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                }
            }
        }
        .navigationBarTitle("Forgot password", displayMode: .inline)
        
    }
}

struct RequestPasswordChangeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State var email: String = ""
    @State var username: String = ""
    
    var body: some View {
        TextField("Email Address", text: $email)
            .padding()
            .background(Color.init("color_textfield"))
            .cornerRadius(8.0)
            .keyboardType(.default)
            .autocapitalization(.none)
            .padding()
        
        TextField("Username", text: $username)
            .padding()
            .background(Color.init("color_textfield"))
            .cornerRadius(8.0)
            .keyboardType(.default)
            .autocapitalization(.none)
            .padding()
        
        Button(action: {
            // add validation here //
            self.userViewModel.forgetPassword(forgetPasswordBody: ForgetPasswordBody(username: username, email: email)) {_ in}
        }, label: {
            Text("Request password change")
                .font(.subheadline)
                .foregroundColor(.white)
        })
        .frame(width: UIScreen.main.bounds.width * 0.6, height: 40, alignment: .center)
        .background(Color.init("color_primary_accent"))
        .cornerRadius(10.0)
        .padding()
    }
}

