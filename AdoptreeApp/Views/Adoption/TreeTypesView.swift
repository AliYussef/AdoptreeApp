//
//  TreeTypesView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeTypesView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if orderViewModel.availableProducts.isEmpty {
                        ProgressView("Loading trees...")
                    } else {
                        
                        ForEach(orderViewModel.availableProducts) { treeProduct in
                            if orderViewModel.categoriesDic[treeProduct.categoryId] == "Sapling"{
                                
                                RoundedRectangle(cornerRadius: 12.0)
                                    .fill(Color.white)
                                    .frame(width: .none, height: 100, alignment: .center)
                                    .overlay(
                                        
                                        HStack(alignment: .top){
                                            Image("tree_type")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 70, height: 70, alignment: .center)
                                            
                                            VStack(alignment: .leading) {
                                                Text("\(treeProduct.name)")
                                                    .font(.title2)
                                                    .bold()
                                                    .foregroundColor(.init("color_font_primary"))
                                                    .padding(.bottom, 2)
                                                
                                                NavigationLink(destination: TreeInfoView(tree: treeProduct))
                                                {
                                                    Label("Tree info", systemImage: "info")
                                                        .foregroundColor(.white)
                                                }
                                                .frame(width: UIScreen.main.bounds.width * 0.30, height: 30, alignment: .center)
                                                .background(Color.init("color_primary_accent"))
                                                .cornerRadius(10.0)
                                            }
                                            .padding(.leading)
                                            
                                            Spacer()
                                        }.padding()
                                    )
                                    .padding(.bottom)
                            }
                        }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
                .padding()
            }
        }
        .onAppear {
            if orderViewModel.availableProducts.isEmpty {
                orderViewModel.getProductsAndCategories()
            }
        }
    }
}

struct TreeTypesView_Previews: PreviewProvider {
    static var previews: some View {
        TreeTypesView()
    }
}
