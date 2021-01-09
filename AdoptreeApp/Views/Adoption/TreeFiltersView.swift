//
//  TreeFiltersView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import MultiSlider

struct TreeFiltersView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @Binding var treeSpeciesIndex: Int
    @Binding var treeConditionIndex: Int
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            Form {
                Section(header: Text(Localization.treeSelectionFilters).foregroundColor(.init("color_font_primary")), content: {
                    Picker(selection: $treeSpeciesIndex, label: Text("Tree species")) {
                        ForEach(0 ..< orderViewModel.treeSpeciesFilter.count) {
                            Text(orderViewModel.treeSpeciesFilter[$0])
                        }
                    }
                    
                    Picker(selection: $treeConditionIndex, label: Text("Tree condition")) {
                        ForEach(0 ..< orderViewModel.treeConditionFilter.count) {
                            Text(orderViewModel.treeConditionFilter[$0])
                        }
                    }
                })
            }.background(Color.init("color_background"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

