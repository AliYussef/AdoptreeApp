//
//  TreeTypeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeTypeView: View {
    @StateObject var orderViewModel: OrderViewModel
    let treeProduct: Product
//    let product = Product(id: 4, categoryId: 3, name: "White oak", description: "", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200))
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 160, alignment: .leading)
            .overlay(
                HStack {
                    Image("tree2")
                        .resizable()
                        .frame(width: 100, height: 125, alignment: .leading)
                    
                    VStack (alignment: .leading) {
                        Text("\(treeProduct.name)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 2)
                        //                        Text("CO2: -1500Kg")
                        //                            .font(.body)
                        //                            .foregroundColor(.init("color_font_secondary"))
                        //                        Text("Age: 3 weeks")
                        //                            .font(.body)
                        //                            .foregroundColor(.init("color_font_secondary"))
                        
                        Text("\(orderViewModel.categoriesDic[treeProduct.categoryId] ?? "Tree")")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        Text("Price: € \(String(format: "%.2f", treeProduct.price)) EUR")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        
                        HStack {
                            Button(action: {
                                self.orderViewModel.add(product: treeProduct)
                                self.orderViewModel.calculateTotal()
                            }, label: {
                                Label("Add", systemImage: "cart.fill.badge.plus")
                                    .foregroundColor(.white)
                            })
                            .frame(width: 100, height: 30, alignment: .center)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                            
                            NavigationLink(destination: TreeInfoView())
                            {
                                Label("Tree info", systemImage: "info")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 100, height: 30, alignment: .center)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                        }
                        .padding(.top, 10)
                        
                    }
                    
                    Spacer()
                }.padding()
            )
            .padding(.bottom, 10)
        //.padding(.bottom, 5)
    }
}

//struct TreeTypeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TreeTypeView()
//    }
//}
