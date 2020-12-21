//
//  TreeTypeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeTypeView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    let treeProduct: Product
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 160, alignment: .leading)
            .overlay(
                HStack {
                    
                    Image("\(orderViewModel.categoriesDic[treeProduct.categoryId]?.lowercased() == "tree" ? "tree" : "sapling")")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .leading)
                    
                    VStack (alignment: .leading) {
                        Text("\(treeProduct.name)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 2)
                        
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
                            
                            NavigationLink(destination: TreeInfoView(tree: treeProduct))
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
    }
}
