//
//  AdoptionOverviewView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionOverviewView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isAdoptionFailed = false
    
    var body: some View {
        if !isAdoptionFailed {
            ZStack{
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Overview")
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
                                    Text("Total:")
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
                                        Text("Cart is empty , go back to add some trees")
                                            .font(.subheadline)
                                            .foregroundColor(.init("color_font_secondary"))
                                            .multilineTextAlignment(.center)
                                            .padding()
                                        
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                            Text("Adopt more")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: 40, alignment: .center)
                        .background(Color.init("color_primary_accent"))
                        .cornerRadius(10.0)
                        .padding()
                        
                        NavigationLink(destination: AdoptionLoginView(isAdoptionFailed: $isAdoptionFailed))
                        {
                            Text("Proceed")
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
            .navigationBarHidden(false)
        } else {
            FailedAdoptionView(isAdoptionFailed: $isAdoptionFailed)
        }
    }
}

struct OverviewCellView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @State var orderProduct: OrderProduct
    @State private var isChecked:Bool = false
    @State private var personalSign = ""
    
    // move to view model
    func deactivateTreeSign() -> EmptyView {
        isChecked.toggle()
        orderViewModel.activateTreeSign(is: isChecked, for: orderProduct.product)
        orderViewModel.calculateTotal()
        
        return EmptyView()
    }
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 220, alignment: .leading)
            .overlay(
                VStack {
                    HStack(alignment: .top) {
                        Image("tree2")
                            .resizable()
                            .frame(width: 40, height: 50, alignment: .leading)
                        
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
                        
                        CustomStepper(orderProduct: orderProduct, value: self.$orderProduct.quantity.animation(), isChecked: $isChecked)
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
                        Text("Adding a personal sign for multiple trees is not possible yet. You can still add one for each tree after the adoption.")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                    } else {
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Personal sign")
                                    .font(.subheadline)
                                    .foregroundColor(.init("color_font_secondary"))
                                TextField("Type personal sign and tick the circle", text: $personalSign)
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
                            Text("Personal sign can be added later as well")
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

struct CustomStepper : View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    let orderProduct: OrderProduct
    @Binding var value: Int
    @Binding var isChecked: Bool
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
