//
//  TreeFiltersView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import MultiSlider

struct TreeFiltersView: View {
    @State private var treeTypeIndex = 0
    @State private var countryIndex = 0
    @State private var forestIndex = 0
    @State private var ageIndex = 0
    @State private var ageValues: [CGFloat] = [1, 30]
    var treeTypeOptions = ["All", "White oak", "Pine"]
    var countryOptions = ["All", "Netherlands", "Bulgaria"]
    var forestNetherlandsOptions = ["All", "Mastbos", "The Amsterdamse Bos"]
    var forestBulgariaOptions = ["All", "Steneto"]
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            Form {
                Section(header: Text("Filters").foregroundColor(.init("color_font_primary")), content: {
                    Picker(selection: $treeTypeIndex, label: Text("Tree type")) {
                        ForEach(0 ..< treeTypeOptions.count) {
                            Text(self.treeTypeOptions[$0])
                        }
                    }
                    Picker(selection: $countryIndex, label: Text("Country")) {
                        ForEach(0 ..< countryOptions.count) {
                            Text(self.countryOptions[$0])
                        }
                    }
                    Picker(selection: $forestIndex, label: Text("Forest")) {
                        ForEach(0 ..< treeTypeOptions.count) {
                            Text(self.treeTypeOptions[$0])
                        }
                        
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Age")
                        
                        MultiValueSlider(
                            value: $ageValues,
                            maximumValue: 130,
                            snapStepSize: 1,
                            valueLabelPosition: .top,
                            orientation: .horizontal,
                            outerTrackColor: .lightGray
                        )
                    }
                    ForEach(ageValues, id: \.self) { v in
                        Text("\(v)")
                    }
                    
                })
            }.background(Color.init("color_background"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct TreeFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        TreeFiltersView()
    }
}
