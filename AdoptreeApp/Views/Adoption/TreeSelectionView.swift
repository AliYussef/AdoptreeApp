//
//  TreeSelectionView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeSelectionView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @State private var badgeCount: Int = 1
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    NavigationLink(destination: TreeFiltersView())
                    {
                        Label("Filters", systemImage: "line.horizontal.3.decrease")
                            .foregroundColor(.black)
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    ZStack {
                        NavigationLink(destination: AdoptionOverviewView())
                        {
                            Label("Cart", systemImage: "cart")
                                .foregroundColor(.black)
                        }.disabled(orderViewModel.products.count < 1)
                        
                        Circle()
                            .fill(Color.init("color_primary_accent"))
                            .overlay(Text("\(self.orderViewModel.products.count)")
                                        .foregroundColor(.white)
                                        .font(.subheadline))
                            .frame(width: 18, height: 18, alignment: .center)
                            .offset(x: -30, y: 4)
                            .opacity(self.orderViewModel.products.count == 0 ? 0.0 : 1.0)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        
                        if orderViewModel.availableProducts.isEmpty {
                            ProgressView("Loading trees...")
                        } else {
                            ForEach(orderViewModel.availableProducts) { treeProduct in
                                
                                if orderViewModel.categoriesDic[treeProduct.categoryId]?.lowercased() == TreeType.tree.rawValue || orderViewModel.categoriesDic[treeProduct.categoryId]?.lowercased() == TreeType.sapling.rawValue{
                                    
                                    TreeTypeView(treeProduct: treeProduct)
                                    
                                }
                            }
                        }
                    }
                }
                Spacer()
                
            }
        }
        .navigationBarTitle("ADOPTION", displayMode: .inline)
        .onAppear {
            if orderViewModel.availableProducts.isEmpty {
                orderViewModel.getProductsAndCategories()
            }
        }
    }
}

