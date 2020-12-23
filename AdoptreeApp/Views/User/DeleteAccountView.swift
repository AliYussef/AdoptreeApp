//
//  DeleteAccountView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct DeleteAccountView: View {
    @ObservedObject var treeViewModel: TreeViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @State var isConfirmDisabled = true
    @State private var showingAlert = false
    @State private var message = ""
    @State var isTryingToDeleteAccount: Bool = false
    @State private var reasonsIndex = 0
    
    var reasons = ["Not interested anymore", "Not convinced", "Too expensive", "Others"]
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Form {
                        Picker(selection: $reasonsIndex, label: Text("Reason").font(.subheadline)) {
                            ForEach(0 ..< reasons.count) {
                                Text(self.reasons[$0])
                            }
                        }
                        
                        SecureField("Confirm password", text: $inputValidationViewModel.password)
                            .validation(inputValidationViewModel.passwordValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                    }.background(Color.init("color_background"))
                    .padding(.top, 50)
                    
                }
                
                Spacer(minLength: 10)
                
                Button(action: {
                    isTryingToDeleteAccount.toggle()
                    userViewModel.deleteUserAccount { result in
                        switch (result) {
                            case .failure(_):
                                message = "An error occurred. Please try again!"
                                showingAlert.toggle()
                            case .success(_):
                                message = "Your account has been deleted! Hope to see you again"
                                showingAlert.toggle()
                        }
                        isTryingToDeleteAccount.toggle()
                    }
                }, label: {
                    Text("Confirm")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(isConfirmDisabled)
                .frame(width: 180, height: 40, alignment: .center)
                .background(isConfirmDisabled ? Color.gray : Color.red)
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Password reset"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
                }
                
            }
            .onReceive(inputValidationViewModel.passwordValidation) { validation in
                isConfirmDisabled = !validation.isSuccess || !treeViewModel.trees.isEmpty
            }
        }
    }
}
