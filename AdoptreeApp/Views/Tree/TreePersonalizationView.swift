//
//  TreePersonalizationView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreePersonalizationView: View {
    @StateObject var treeViewModel: TreeViewModel
    @State var tree: Tree
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var treeName = ""
    @State private var treeColor = Color.init("color_primary_accent")
    @State private var showingAlert = false
    @State private var message = ""
    
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
                    tree.assignedTree?.tree_name = treeName
                    tree.assignedTree?.tree_color = UIColor(treeColor).toHex()
                    if let tree = tree.assignedTree {
                        treeViewModel.personalizeTree(tree: tree) { result in
                            switch (result) {
                                case .failure(_):
                                    self.message = "An error occurred. Please try again!"
                                    self.showingAlert.toggle()
                                case .success(_):
                                    self.message = "Successfully edited"
                                    self.showingAlert.toggle()
                                    presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }, label: {
                    Text("Confirm")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Presonalisation"), message: Text("\(message)"), dismissButton: .default(Text("Ok")))
                }
                
            }
            .padding()
        }
        .onAppear {
            if let treeColor = tree.assignedTree?.tree_color {
                self.treeColor = Color(UIColor(hex: treeColor) ?? UIColor(Color.init("color_primary_accent")))
            }
            
            if let treeName = tree.assignedTree?.tree_name {
                self.treeName = treeName
            }
        }
    }
}

