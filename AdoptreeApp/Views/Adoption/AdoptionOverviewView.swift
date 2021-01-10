//
//  AdoptionOverviewView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionOverviewView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isAdoptionFailed = false
    @State private var actionState: Int? = 0
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    
    var body: some View {
        if !isAdoptionFailed {
            ZStack {
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text(Localization.adoptionOverViewTitle)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.top)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            
                            ForEach(orderViewModel.products) { product in
                                OverviewCellView(orderProduct: product)
                            }
                            
                            if orderViewModel.products.count > 0 {
                                HStack {
                                    Text(Localization.adoptionOverViewTotalPrice)
                                        .font(.footnote)
                                        .foregroundColor(.init("color_font_secondary"))
                                    
                                    Spacer()
                                    
                                    Text("€\(String(format: "%.2f", self.orderViewModel.totalPrice)) EUR")
                                        .font(.footnote)
                                        .foregroundColor(.init("color_font_secondary"))
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
                                .background(Color.white)
                                .cornerRadius(12.0)
                                .padding(.bottom, 10)
                            } else {
                                RoundedRectangle(cornerRadius: 12.0)
                                    .fill(Color.white)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 100, alignment: .center)
                                    .overlay(
                                        Text(Localization.adoptionOverViewCartEmpty)
                                            .font(.subheadline)
                                            .foregroundColor(.init("color_font_secondary"))
                                            .multilineTextAlignment(.center)
                                            .padding()
                                        
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SuccessfulAdoptionView(), tag: 1, selection: $actionState) {
                        EmptyView()
                    }
                    
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                            Text(Localization.addMoreBtn)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: 40, alignment: .center)
                        .background(Color.init("color_primary_accent"))
                        .cornerRadius(10.0)
                        .padding()
                        
                        if userViewModel.isAuthenticated {
                            Button(action: {
                                createOrder()
                            }, label: {
                                Text(Localization.payBtn)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            })
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: 40, alignment: .center)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                            .padding()
                            .disabled(orderViewModel.products.count == 0)
                            
                        } else {
                            
                            NavigationLink(destination: AdoptionLoginView(isAdoptionFailed: $isAdoptionFailed))
                            {
                                Text(Localization.proceedBtn)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: 40, alignment: .center)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                            .padding()
                            .disabled(orderViewModel.products.count == 0)
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.loginAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                }
                .onOpenURL(perform: { url in
                    if url.host == "payment-return" {
                        checkOrderStatus()
                    }
                })
            }
            .navigationBarHidden(false)
            
        } else {
            FailedAdoptionView(isAdoptionFailed: $isAdoptionFailed)
        }
    }
}

extension AdoptionOverviewView {
    
    func createOrder() {
        if let userId = userViewModel.userShared.id {
            let order = orderViewModel.createOrderObject(for: userId)
            orderViewModel.createOrder(order: order) { result in
                switch (result) {
                    case .failure(_):
                        message = Localization.errorOccurred
                        showingAlert.toggle()
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
    
    func checkOrderStatus() {
        if let orderId = orderViewModel.orderResponse?.id {
            orderViewModel.getOrderById(using: orderId) { result in
                switch (result) {
                    case .failure(_):
                        break
                    case .success(_):
                        if orderViewModel.order?.orderLines[0].productId != orderViewModel.treeSign?.id {
                            if let paymentStatus = orderViewModel.order?.paymentStatus {
                                if paymentStatus == PaymentStatus.paid.rawValue || paymentStatus == PaymentStatus.open.rawValue {
                                    orderViewModel.products.removeAll()
                                    actionState = 1
                                } else {
                                    self.isAdoptionFailed.toggle()
                                }
                            }
                        }
                }
            }
        }
    }
}

struct OverviewCellView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @State var orderProduct: OrderProduct
    @State private var isChecked:Bool = false
    @State private var personalSign = ""
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 220, alignment: .leading)
            .overlay(
                VStack {
                    HStack(alignment: .top) {
                        Image("\(orderViewModel.categoriesDic[orderProduct.product.categoryId]?.lowercased() == TreeType.tree.rawValue ? TreeType.tree.rawValue : TreeType.sapling.rawValue)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 50, alignment: .leading)
                            .foregroundColor(.init("color_primary_accent"))
                        
                        VStack (alignment: .leading) {
                            Text("\(orderProduct.product.name)")
                                .font(.subheadline)
                                .foregroundColor(.init("color_font_secondary"))
                                .padding(.bottom, 1)
                            
                            HStack {
                                Text("\(orderProduct.quantity) x")
                                    .font(.subheadline)
                                    .foregroundColor(.init("color_font_secondary"))
                                    .padding(.bottom, 1)
                                
                                Text("€\(String(format: "%.2f", orderProduct.product.price * Double(orderProduct.quantity))) EUR")
                                    .font(.subheadline)
                                    .foregroundColor(.init("color_font_secondary"))
                                    .padding(.bottom, 1)
                            }
                        }
                        
                        CustomStepper(value: self.$orderProduct.quantity.animation(), isChecked: $isChecked, orderProduct: orderProduct)
                            .padding(.trailing)
                        
                        Button(action: {
                            withAnimation {
                                self.orderViewModel.remove(product: orderProduct.product)
                                self.orderViewModel.calculateTotal()
                            }
                        }, label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        })
                    }
                    
                    Divider()
                    
                    if self.orderViewModel.products.count > 1 || orderProduct.quantity > 1 {
                        Text(Localization.adoptionOverViewPersonalSignNote)
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                    } else {
                        HStack {
                            VStack (alignment: .leading) {
                                Text(Localization.personalSignText)
                                    .font(.subheadline)
                                    .foregroundColor(.init("color_font_secondary"))
                                TextField(Localization.adoptionOverViewPersonalSignAddNote, text: $personalSign)
                                    .font(.subheadline)
                                
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    self.isChecked.toggle()
                                    self.orderViewModel.activateTreeSign(is: isChecked, for: orderProduct.product)
                                    self.orderViewModel.calculateTotal()
                                }
                            }, label: {
                                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.init("color_primary_accent"))
                            })
                        }
                        .padding(.top)
                        
                        Divider()
                        
                        HStack {
                            Text(Localization.adoptionOverViewPersonalSignAddLaterNote)
                                .font(.footnote)
                                .foregroundColor(.init("color_font_secondary"))
                            Spacer()
                            Text("€\(String(format: "%.2f", orderViewModel.treeSign?.price ?? 5.0) ) EUR")
                                .font(.subheadline)
                                .foregroundColor(.init("color_font_secondary"))
                        }
                    }
                }
                .padding()
            )
            .padding(.bottom, 10)
    }
}

extension OverviewCellView {
    
    func deactivateTreeSign() -> EmptyView {
        isChecked.toggle()
        orderViewModel.activateTreeSign(is: isChecked, for: orderProduct.product)
        orderViewModel.calculateTotal()
        
        return EmptyView()
    }
    
}

struct CustomStepper : View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @Binding var value: Int
    @Binding var isChecked: Bool
    let orderProduct: OrderProduct
    var step = 1
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Button(action: {
                if self.value > 1 {
                    self.value -= self.step
                    self.orderViewModel.decreaseQuantity(of: orderProduct.product)
                    self.orderViewModel.calculateTotal()
                    
                }
            }, label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(value > 1 ? Color.init("color_primary_accent") : Color.gray)
                
            })
            
            Button(action: {
                if self.value >= 0 {
                    self.value += self.step
                    self.orderViewModel.increaseQuantity(of: orderProduct.product)
                    self.orderViewModel.calculateTotal()
                    
                    if isChecked {
                        self.isChecked.toggle()
                        self.orderViewModel.activateTreeSign(is: isChecked, for: orderProduct.product)
                        self.orderViewModel.calculateTotal()
                    }
                    
                }
            }, label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(value >= 0 ? Color.init("color_primary_accent") : Color.gray)
            })
        }
    }
}
