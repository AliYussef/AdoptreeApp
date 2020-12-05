//
//  AdoptionLoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionLoginView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username = ""
    @State private var password = ""
    
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
                    var orderLines: [OrderLine] = []
                    self.orderViewModel.products.forEach({ orderProduct in
                        orderLines.append(OrderLine(id: nil, orderId: nil, productId: orderProduct.product.id, price: nil, vat: nil, quantity: orderProduct.quantity))
                    })
                    let order = Order(id: nil, paymentStatus: nil, orderStatus: nil, userId: 1, createdAt: nil, orderLines: orderLines)
                    
                    self.orderViewModel.createOrder(order: order) {_ in}
                    
                    if let paymentLink = self.orderViewModel.order?.paymentLink {
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

struct AdoptionLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptionLoginView()
    }
}
