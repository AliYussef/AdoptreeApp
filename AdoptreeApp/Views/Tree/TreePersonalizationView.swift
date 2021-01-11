//
//  TreePersonalizationView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreePersonalizationView: View {
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    let tree: Tree
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var treeName = ""
    @State private var treeColor = Color.init("color_primary_accent")
    @State private var showingAlert = false
    @State private var message = LocalizedStringKey("")
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(alignment: .leading) {
                    Text(Localization.TreePersonalizationTitle)
                        .font(.title)
                        .foregroundColor(.init("color_font_primary"))
                    
                    Form {
                        Section(header: Text(Localization.TreePersonalizationTreeDetails), content: {
                            TextField(Localization.TreePersonalizationTreeName, text: $treeName)
                            ColorPicker(Localization.TreePersonalizationTreeColor, selection: $treeColor)
                        })
                    }
                }
                
                Button(action: {
                    personalizeTree()
                }, label: {
                    Text(Localization.confirmBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.TreePersonalizationAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
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

extension TreePersonalizationView {
    func personalizeTree() {
        
        if var tree = tree.assignedTree {
            tree.tree_name = treeName
            tree.tree_color = UIColor(treeColor).toHex()
            treeViewModel.personalizeTree(tree: tree) { result in
                switch (result) {
                    case .failure(_):
                        self.message = Localization.errorOccurred
                        self.showingAlert.toggle()
                        
                    case .success(let tree):
                        updateTimelineView(tree: tree)
                        self.message = Localization.successfullyEdited
                        self.showingAlert.toggle()
                        presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
    }
    
    func updateTimelineView(tree: AssignedTree) {
        if let treeColor = tree.tree_color {
            if let treeName = tree.tree_name {
                timelineViewModel.timelineTreeDic[tree.tree_id]?.treeName = treeName
                timelineViewModel.timelineTreeDic[tree.tree_id]?.treeColor = treeColor
                
                if let index = timelineViewModel.treeTypeFilter.firstIndex(where: {$0.treeId == tree.tree_id}) {
                    timelineViewModel.treeTypeFilter[index].treeName = treeName
                }
            }
        }
    }
    
}
