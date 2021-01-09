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
    @State private var message = LocalizedStringKey("")
    let tree: Tree
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Label(
                    title: {
                        Text("\((tree.assignedTree?.tree_name?.isEmpty ?? false ? "\(Localization.homeTree)" : tree.assignedTree?.tree_name) ?? "\(Localization.homeTree)")")
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
                        Alert(title: Text(Localization.adoptedTreesAlertTitle), message: Text(message), primaryButton: .default(Text(Localization.yesBtn)){
                            //might add payment as well
                            if let tree = tree.assignedTree {
                                treeViewModel.renewTreeContract(for: tree) { result in
                                    switch (result) {
                                        case .failure(_):
                                            message = Localization.errorOccurred
                                            showingAlert.toggle()
                                        case .success(_):
                                            message = Localization.successfulContractRenewal
                                            showingAlert.toggle()
                                    }
                                }
                            }
                        },secondaryButton: .cancel(Text(Localization.noBtn)))
                    }
                
                Spacer()
                
                if isTreeUpForRenewal(expiredDate: calculateTreeExpiredDate()) {
                    Button(action: {
                        message = Localization.contractRenewalConfirm
                        showingAlertConfirm.toggle()
                    }, label: {
                        HStack {
                            Text(Localization.adoptedTreesRenewBtn)
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
                        Alert(title: Text(Localization.adoptedTreesAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
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
                            Text(Localization.adoptedTreesTreeType)
                            Spacer()
                            Text("\(orderViewModel.availableProducts.first(where: {$0.id == tree.productId})?.name ?? "\(Localization.homeTree)")")
                                .foregroundColor(.init("color_font_secondary"))
                        }
                        
                        HStack {
                            Text(Localization.adoptedTreesCountry)
                            Spacer()
                            if let treeId = tree.assignedTree?.tree_id {
                                Text("\(treeViewModel.treeLocationDic[treeId]?.country ?? "\(Localization.adoptedTreesUnknown)")")
                                    .foregroundColor(.init("color_font_secondary"))
                            }
                        }
                        
                        HStack {
                            Text(Localization.adoptedTreesForest)
                            Spacer()
                            if let treeId = tree.assignedTree?.tree_id {
                                Text("\(treeViewModel.treeLocationDic[treeId]?.forest ?? "\(Localization.adoptedTreesUnknown)")")
                                    .foregroundColor(.init("color_font_secondary"))
                            }
                        }
                        
                        HStack {
                            Text(Localization.adoptedTreesStartDate)
                            Spacer()
                            Text(getHumanReadableDate(date: tree.assignedTree?.created_at ?? Date()))
                                .foregroundColor(.init("color_font_secondary"))
                        }
                        
                        HStack {
                            Text(Localization.adoptedTreesEndDate)
                            Spacer()
                            Text(getHumanReadableDate(date: calculateTreeExpiredDate()))
                                .foregroundColor(.init("color_font_secondary"))
                        }
                    }).padding(.bottom)
        }.frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

extension AdoptedTreesCell {
    
    func isTreeUpForRenewal(expiredDate: Date) -> Bool {
        var dateDiff = DateComponents()
        
        if let from = tree.assignedTree?.created_at {
            dateDiff = Calendar.current.dateComponents([.day], from: from, to: expiredDate)
        }
        
        guard dateDiff.day != nil else {
            return false
        }
        
        return dateDiff.day! < 30
    }
    
    func calculateTreeExpiredDate() -> Date {
        if let tree = tree.assignedTree {
            let timeInterval = DateComponents(year: 1)
            let expiredDate = Calendar.current.date(byAdding: timeInterval, to: tree.created_at)
            if let expiredDate = expiredDate {
                return expiredDate
            }
        }
        return Date()
    }
    
    func getHumanReadableDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}
