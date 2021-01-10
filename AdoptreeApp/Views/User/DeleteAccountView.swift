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
    @State private var message = LocalizedStringKey("")
    @State var isTryingToDeleteAccount: Bool = false
    @State private var reasonsIndex = 0
    var reasons = [Localization.deleteAccountFirstReason, Localization.deleteAccountSecondReason, Localization.deleteAccountThirdReason, Localization.deleteAccountFourthReason]
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Form {
                        Picker(selection: $reasonsIndex, label: Text(Localization.deleteAccountReason).font(.subheadline)) {
                            ForEach(0 ..< reasons.count) {
                                Text(self.reasons[$0])
                            }
                        }
                        
                        SecureField(Localization.passwordField, text: $inputValidationViewModel.password)
                            .validation(inputValidationViewModel.passwordValidation)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        Text(Localization.deleteAccountNote)
                            .font(.footnote)
                            .foregroundColor(.init("color_font_secondary"))
                        
                    }.background(Color.init("color_background"))
                    .padding(.top, 50)
                    
                }
                
                Spacer(minLength: 10)
                
                Button(action: {
                    isTryingToDeleteAccount.toggle()
                    deleteUserAccount()
                }, label: {
                    Text(Localization.confirmBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .disabled(isConfirmDisabled)
                .frame(width: 180, height: 40, alignment: .center)
                .background(isConfirmDisabled ? Color.gray : Color.red)
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.deleteAccountAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                }
                
                if isTryingToDeleteAccount {
                    withAnimation(.linear) {
                        ZStack {
                            Image("tree")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.0)
                                .background(Blur(style: .systemUltraThinMaterial))
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView(Localization.deleteAccountProgress)
                        }
                    }
                }
                
            }
            .onReceive(inputValidationViewModel.passwordValidation) { validation in
                isConfirmDisabled = !validation.isSuccess || !treeViewModel.trees.isEmpty
            }
        }
    }
}

extension DeleteAccountView {
    
    func deleteUserAccount() {
        userViewModel.deleteUserAccount { result in
            switch (result) {
                case .failure(_):
                    message = Localization.errorOccurred
                    showingAlert.toggle()
                case .success(_):
                    message = Localization.successfulAccountDeletion
                    showingAlert.toggle()
            }
            isTryingToDeleteAccount.toggle()
        }
    }
}
