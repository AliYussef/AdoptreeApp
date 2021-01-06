//
//  AdoptedTreesView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 22/12/2020.
//

import SwiftUI

struct AdoptedTreesView: View {
    @EnvironmentObject var treeViewModel: TreeViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(treeViewModel.trees) { tree in
                    AdoptedTreesCell(tree: tree)
                }
            }
            .padding(.top)
        }
    }
}

struct AdoptedTreesCell: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    @State private var showingAlert = false
    @State private var showingAlertConfirm = false
    @State private var message = ""
    let tree: Tree
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Label(
                    title: {
                        Text("\((tree.assignedTree?.tree_name?.isEmpty ?? false ? "Tree" : tree.assignedTree?.tree_name) ?? "Tree")")
                            .font(.title2)
                    },
                    icon: {
                        Image("tree")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.init("color_primary_accent"))
                    })
                    .alert(isPresented: $showingAlertConfirm) {
                        Alert(title: Text("Contract renewal"), message: Text("\(message)"), primaryButton: .default(Text("Yes")){
                            //might add payment as well
                            if let tree = tree.assignedTree {
//                                treeViewModel.renewTreeContract(for: tree) { result in
//                                    switch (result) {
//                                        case .failure(_):
//                                            message = "An Error has occurred. Please try again!"
//                                            showingAlert.toggle()
//                                        case .success(_):
//                                            message = "Congratulations􀎸 your adoption has been extended by 1 year"
//                                            showingAlert.toggle()
//                                    }
//                                }
                            }
                        },secondaryButton: .cancel(Text("No")))
                    }
                
                Spacer()
                
                if isTreeUpForRenewal() {
                    Button(action: {
                        message = "Are you sure you want to extend your adoption?"
                        showingAlertConfirm.toggle()
                    }, label: {
                        HStack {
                            Text("Renew")
                                .font(.footnote)
                                .foregroundColor(.white)
                            
                            Image(systemName: "leaf.arrow.triangle.circlepath")
                                .foregroundColor(.white)
                        }.padding([.leading, .trailing], 5)
                    })
                    .padding(3)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Contract renewal"), message: Text("\(message)"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .padding([.leading, .trailing, .bottom])
            
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 245, alignment: .leading)
                .overlay(
                    List {
                        HStack {
                            Text("Tree Type")
                            Spacer()
                            Text("\(orderViewModel.availableProducts.first(where: {$0.id == tree.productId})?.name ?? "Tree")")
                                .foregroundColor(.init("color_font_secondary"))
                        }
                        
                        HStack {
                            Text("Country")
                            Spacer()
                            if let treeId = tree.assignedTree?.tree_id {
                                Text("\(treeViewModel.treeLocationDic[treeId]?.country ?? "Unknown")")
                                    .foregroundColor(.init("color_font_secondary"))
                            }
                        }
                        
                        HStack {
                            Text("Forest")
                            Spacer()
                            if let treeId = tree.assignedTree?.tree_id {
                                Text("\(treeViewModel.treeLocationDic[treeId]?.forest ?? "Unknown")")
                                    .foregroundColor(.init("color_font_secondary"))
                            }
                        }
                        
                        HStack {
                            Text("Start date")
                            Spacer()
                            Text(getHumanReadableDate(date: tree.assignedTree?.created_at ?? Date()))
                                .foregroundColor(.init("color_font_secondary"))
                        }
                        
                        HStack {
                            Text("End date")
                            Spacer()
                            Text(getHumanReadableDate(date: tree.assignedTree?.expire_date ?? Date()))
                                .foregroundColor(.init("color_font_secondary"))
                        }
                    }).padding(.bottom)
        }.frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

extension AdoptedTreesCell {
    
    func isTreeUpForRenewal() -> Bool {
        var dateDiff = DateComponents()
        
        if let from = tree.assignedTree?.created_at {
            if let to = tree.assignedTree?.expire_date {
                dateDiff = Calendar.current.dateComponents([.day], from: from, to: to)
            }
        }
        
        guard dateDiff.day != nil else {
            return false
        }
        
        return dateDiff.day! < 30
    }
    
    func getHumanReadableDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}
