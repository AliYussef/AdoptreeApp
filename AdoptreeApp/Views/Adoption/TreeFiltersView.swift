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
    
    
    //    var image: some View {
    //        if let nsData = "e352dbd4-77e3-4bcc-9013-bfd1b7dee739", let uiImage = UIImage(data: nsData as Data) {
    //            return AnyView(Image(uiImage: uiImage)
    //                            .resizable()
    //                            .frame(width: 120, height: 120, alignment: .center)
    //                            .aspectRatio(contentMode: .fill))
    //        }
    //        return AnyView(EmptyView())
    //    }
    
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
                    //                    NavigationLink(
                    //                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    //                        label: {
                    //                            Text("Age")
                    //                        })
                    VStack (alignment: .leading) {
                        Text("Age")
                        //Text(String($doubleValue))
                        
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
                        //let va = "\(v)"
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
