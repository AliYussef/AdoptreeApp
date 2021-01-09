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
    @EnvironmentObject var treeViewModel: TreeViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(Localization.contractTitle)
                    .font(.title2)
                    .foregroundColor(.init("color_font_primary"))
                    .padding([.top, .leading])
                
                List {
                    HStack {
                        Text(Localization.contractName)
                        Spacer()
                        Text("\(userViewModel.userShared.firstname ?? "\(Localization.profileYour)") \(userViewModel.userShared.lastname ?? "\(Localization.profileName)")")
                            .foregroundColor(.init("color_font_secondary"))
                    }
                    
                    NavigationLink(
                        destination: AdoptedTreesView(),
                        label: {
                            Text(Localization.contractAdoptedTrees)
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
