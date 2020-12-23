//
//  ContractView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct ContractView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var orderViewModel: OrderViewModel
    @ObservedObject var treeViewModel: TreeViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Contract")
                    .font(.title2)
                    .foregroundColor(.init("color_font_primary"))
                    .padding([.top, .leading])
                
                List {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("\(userViewModel.userShared.firstname ?? "YOUR") \(userViewModel.userShared.lastname ?? "NAME")")
                            .foregroundColor(.init("color_font_secondary"))
                    }
                    
                    NavigationLink(
                        destination: AdoptedTreesView(treeViewModel: treeViewModel),
                        label: {
                            Text("Adopted trees")
                                .foregroundColor(.black)
                        })
                }
            }
        }
        .onAppear {
            if treeViewModel.countries.isEmpty && treeViewModel.forests.isEmpty {
                treeViewModel.getForestsAndCountries()
            }
            
            if orderViewModel.availableProducts.isEmpty {
                orderViewModel.getProductsAndCategories()
            }
        }
    }
}
