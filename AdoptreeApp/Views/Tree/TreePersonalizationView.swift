//
//  TreePersonalizationView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreePersonalizationView: View {
    // let tree: Tree
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var treeName = ""
    @State private var treeColor = Color.init("color_primary_accent")
  
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(alignment: .leading) {
                    Text("Personalize your tree")
                        .font(.title)
                        .foregroundColor(.init("color_font_primary"))
                    
                    Form {
                        Section(header: Text("Tree details"), content: {
                            TextField("Tree name", text: $treeName)
                            ColorPicker("Tree color", selection: $treeColor)
                        })
                    }
                }
                
                Button(action: {
                    //call api and save changes
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Confirm")
                        .bold()
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 50, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
            .padding()
        }
        .onAppear {
           // self.treeColor = Color(UIColor(hex: (tree.assignedTree?.tree_color)!)!)
        }
    }
}

struct TreePersonalizationView_Previews: PreviewProvider {
    static var previews: some View {
        TreePersonalizationView()
    }
}
