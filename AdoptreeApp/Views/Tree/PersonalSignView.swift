//
//  PersonalSignView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct PersonalSignView: View {
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var treeSign = ""
    @State private var hasTreeSign: Bool = false
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    let tree: Tree
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text(Localization.personalSignTitle)
                    .font(.title)
                    .foregroundColor(.init("color_font_primary"))
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .leading)
                
                Spacer(minLength: 50)
                
                VStack {
                    Text(Localization.personalSignText)
                        .font(.title3)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 2)
                    
                    Text(Localization.personalSignNote)
                        .font(.subheadline)
                        .foregroundColor(.init("color_font_primary"))
                }
                .padding()
                
                Form {
                    Section(header: Text(Localization.personalSignTreeSign), content: {
                        TextField(Localization.personalSignText, text: $treeSign)
                        if hasTreeSign {
                            Text(Localization.personalSignHasTreeSignNote)
                                .font(.footnote)
                                
                                .multilineTextAlignment(.center)
                                .foregroundColor(.init("color_font_secondary"))
                        }
                    })
                }
                
                Button(action: {
                    if treeSign.count == 0 {
                        self.message = Localization.personalSignEmptyAlert
                        self.showingAlert.toggle()
                        
                    } else {
                        if let userId = userViewModel.userShared.id {
                            let order = orderViewModel.createTreeSignOrder(for: userId)
                            orderViewModel.createOrder(order: order) { result in
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
                        }
                    }
                }, label: {
                    Text(Localization.confirmPayBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 40, alignment: .center)
                .background(hasTreeSign ? Color.gray : Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.personalSignText), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                }
                .disabled(hasTreeSign)
                
            }
            .padding()
        }
        .onAppear {
            
            if treeViewModel.treeSign.isEmpty {
                if let treeId = tree.assignedTree?.tree_id {
                    treeViewModel.getTreeSignByTree(for: treeId) { result in
                        switch result {
                            case .failure(_):
                                break
                            case .success(let sign):
                                self.treeSign = sign.sign_text
                                self.hasTreeSign = true
                        }
                    }
                }
            }
            
            if orderViewModel.availableProducts.isEmpty {
                orderViewModel.getProductsAndCategories()
            }
            
        }.onOpenURL(perform: { url in
            if url.host == "payment-return" {
                if let orderId = orderViewModel.orderResponse?.id {
                    orderViewModel.getOrderById(using: orderId) { result in
                        switch (result) {
                            case .failure(_):
                                break
                            case .success(_):
                                if orderViewModel.order?.orderLines[0].productId == orderViewModel.treeSign?.id {
                                    if let paymentStatus = orderViewModel.order?.paymentStatus {
                                        if paymentStatus == PaymentStatus.paid.rawValue || paymentStatus == PaymentStatus.open.rawValue {
                                            
                                            if let treeSignProduct = orderViewModel.treeSign {
                                                if let orderId = orderViewModel.orderResponse?.id {
                                                    let treeSign = treeViewModel.createTreeSignObject(tree: tree, treeSignProduct: treeSignProduct, signText: self.treeSign, orderId: orderId)
                                                    
                                                    if let treeSign = treeSign {
                                                        treeViewModel.createTreeSign(treeSign: treeSign) {  result in
                                                            switch (result) {
                                                                case .failure(_):
                                                                    break
                                                                case .success(_):
                                                                    self.message = Localization.successfulSignPurchase
                                                                    self.showingAlert.toggle()
                                                                    presentationMode.wrappedValue.dismiss()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            self.message = Localization.errorOccurred
                                            self.showingAlert.toggle()
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
