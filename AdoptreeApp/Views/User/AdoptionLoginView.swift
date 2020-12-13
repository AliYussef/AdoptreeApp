//
//  AdoptionLoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionLoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.openURL) var openURL
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
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
                    //login here first
                    // self.userViewModel.login(user: T##User, completion: T##(Result<LoginResponse, RequestError>) -> Void))
                    let order = self.orderViewModel.createOrderObject(for: 1)
                    self.orderViewModel.createOrder(order: order) { result in
                        switch (result) {
                            case .failure(let error):
                                print(error)
                            case .success(let success):
                                print(success)
                                //UIApplication.shared.open(NSURL(string: success.paymentLink)! as URL)
                                
                                if let url = URL(string: success.paymentLink) {
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }
                                
                            //self.openURL(URL(string: success.paymentLink)!)
                            //                                if let paymentLink = self.orderViewModel.order?.paymentLink {
                            //                                    self.openURL(URL(string:  paymentLink)!)
                            //                                }
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
                
                //                NavigationLink(destination: FailedAdoptionView(), tag: 2, selection: $actionState) {
                //                    EmptyView()
                //                }
                
            }
        } .onOpenURL(perform: { url in
            if url.host == "payment-return" {
                if let orderId = orderViewModel.orderResponse?.id {
                    orderViewModel.getOrderById(using: orderId) { result in
                        switch (result) {
                            case .failure(let error):
                                print(error)
                            case .success(let success):
                                print(success)
                                if let paymentStatus = orderViewModel.order?.paymentStatus {
                                    if paymentStatus == PaymentStatus.paid.rawValue || paymentStatus == PaymentStatus.open.rawValue {
                                        orderViewModel.products.removeAll()
                                        print("payment successfull")
                                        actionState = 1
                                    } else {
                                        print("payment unsuccessfull")
                                        self.isAdoptionFailed.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        })
        
    }
}
