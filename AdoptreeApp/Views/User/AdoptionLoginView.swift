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
    @State private var username = ""
    @State private var password = ""
    @State private var actionState: Int? = 0
    @Binding var isAdoptionFailed: Bool
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.init("color_textfield"))
                    .cornerRadius(8.0)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.init("color_textfield"))
                    .cornerRadius(8.0)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                
                HStack {
                    Text("No account yet?")
                        .font(.subheadline)
                        .foregroundColor(.init("color_font_primary"))
                    
                    NavigationLink(destination: SignupView())
                    {
                        Text("Sign up")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    let user = User(id: nil, firstname: inputValidationViewModel.firstName, lastname: inputValidationViewModel.lastName, username: inputValidationViewModel.username, email: inputValidationViewModel.email, password: inputValidationViewModel.password, forgetToken: nil, role: nil, createdAt: nil)
                    userViewModel.login(user: user) { result in
                        switch (result) {
                            case .failure(_):
                                break
                            case .success(let response):
                                //userViewModel.accessToken = response.authtoken
                                //if let userId = user.id {
                                    let order = self.orderViewModel.createOrderObject(for: 1)
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
                                //}
                        }
                        
                    }
                }, label: {
                    Text("Log in & pay")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: 160, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
                NavigationLink(destination: SuccessfullAdoptionView(), tag: 1, selection: $actionState) {
                    EmptyView()
                }
                
            }
        }.onOpenURL(perform: { url in
            if url.host == "payment-return" {
                if let orderId = orderViewModel.orderResponse?.id {
                    orderViewModel.getOrderById(using: orderId) { result in
                        switch (result) {
                            case .failure(_):
                                break
                            case .success(_):
                                //print(success)
                                if orderViewModel.order?.orderLines[0].productId != orderViewModel.treeSign?.id {
                                    if let paymentStatus = orderViewModel.order?.paymentStatus {
                                        if paymentStatus == PaymentStatus.paid.rawValue || paymentStatus == PaymentStatus.open.rawValue {
                                            orderViewModel.products.removeAll()
                                            //print("payment successfull")
                                            actionState = 1
                                        } else {
                                            // print("payment unsuccessfull")
                                            self.isAdoptionFailed.toggle()
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        })
        
    }
}
