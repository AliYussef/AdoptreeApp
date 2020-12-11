//
//  SignupView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
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
                        TextField("First name", text: $firstName)
                        TextField("Last name", text: $lastName)
                        TextField("Email", text: $email)
                        TextField("Username", text: $username)
                        TextField("Password", text: $password)
                        TextField("Confirm password", text: $confirmPassword)
                    })
                }.background(Color.init("color_background"))
                .padding(.top, 50)
                
                Button(action: {
                    //login here first
                    // self.userViewModel.login(user: T##User, completion: T##(Result<LoginResponse, RequestError>) -> Void))
                    var orderLines: [OrderLine] = []
                    self.orderViewModel.products.forEach({ orderProduct in
                        orderLines.append(OrderLine(id: nil, orderId: nil, productId: orderProduct.product.id, price: nil, vat: nil, quantity: orderProduct.quantity))
                    })
                    let order = Order(id: nil, paymentRedirectLink: "mollie-app://payment-return", paymentStatus: nil, orderStatus: nil, userId: 1, createdAt: nil, orderLines: orderLines)
                    
                    self.orderViewModel.createOrder(order: order) {_ in}
                    
                    if let paymentLink = self.orderViewModel.orderResponse?.paymentLink {
                        self.openURL(URL(string:  paymentLink)!)
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
                
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
