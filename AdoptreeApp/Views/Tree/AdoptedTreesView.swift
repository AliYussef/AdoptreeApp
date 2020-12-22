//
//  AdoptedTreesView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 22/12/2020.
//

import SwiftUI

struct AdoptedTreesView: View {
    @ObservedObject var treeViewModel: TreeViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(treeViewModel.trees) { tree in
                    AdoptedTreesCell(treeViewModel: treeViewModel, tree: tree)
                }
            }
        }
    }
}

struct AdoptedTreesView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptedTreesView(treeViewModel: .init(treeRepository: TreeRepository(), userRepository: UserRepository(), countryRepository: CountryRepository(), forestRepository: ForestRepository(), treeSignRepository: TreeSignRepository()))
    }
}

struct AdoptedTreesCell: View {
    @ObservedObject var treeViewModel: TreeViewModel
    let tree: Tree
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Label(
                    title: {
                        Text("\(tree.assignedTree?.tree_name ?? "Tree")")
                            .font(.title2)
                    },
                    icon: {
                        Image("tree")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                    })
                
                Spacer()
                
                if isTreeUpForRenewal() {
                    Button(action: {
                        
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
                }
            }
            .padding([.leading, .trailing])
            
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 192, alignment: .leading)
                .overlay(
                    List {
                        HStack {
                            Text("Tree Type")
                            Spacer()
                            Text("White oak")
                                .foregroundColor(.init("color_font_secondary"))
                        }
                        
                        HStack {
                            Text("Location")
                            Spacer()
                            Text("Netherlands")
                                .foregroundColor(.init("color_font_secondary"))
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
