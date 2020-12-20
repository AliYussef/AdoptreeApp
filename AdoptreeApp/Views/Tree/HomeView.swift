//
//  HomeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var treeViewModel: TreeViewModel
    @ObservedObject var timelineViewModel: TimelineViewModel
    
    var telemetry = [
        Telemetry(id: "1", treeId: "1", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1111795200), temperature: -3, humidity: 90, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1113004800), temperature: 23, humidity: 80, treeLength: 20, treeDiameter: 20)]),
        Telemetry(id: "2", treeId: "2", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1112400000), temperature: 22, humidity: 80, treeLength: 22, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1115424000), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)]),
        Telemetry(id: "3", treeId: "3", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1112400000), temperature: 22, humidity: 80, treeLength: 22, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1115424000), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)])
    ]
    
    var body: some View {
        
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            if userViewModel.isAuthenticated {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if treeViewModel.trees.isEmpty {
                            ProgressView("Loading your trees...")
                            //                            .onAppear {
                            //                                userViewModel.getAdoptedTrees() {_ in}
                            //                            }
                            
                        } else {
                            
                            ForEach(Array(zip(treeViewModel.trees.indices, treeViewModel.trees)), id: \.0) { index, tree in
                                
                                DisclosureGroup(
                                    isExpanded: $treeViewModel.isExpanded[index],
                                    content: {
                                        if let treeId = tree.assignedTree?.tree_id {
                                            TreeView(tree: tree, telemetry: telemetry.filter({Int64($0.treeId)! == treeId}).first?.reports.first ?? nil, sequestration: timelineViewModel.sequestrations.filter({$0.treeId == treeId}).first?.sequestration, treeImage: treeViewModel.treeImages.filter({$0.tree_id == treeId}).first, wildlife: treeViewModel.wildlifes.filter({$0.forestId == tree.forestId}).first?.wildlife)
                                        }
                                    },
                                    label: {
                                        
                                        TreeHeader(treeViewModel: treeViewModel, tree: tree)
                                            .frame(width: .none, height: .none)
                                    })
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width - 20, height: .none)
                                    .background(Color.white)
                                    .cornerRadius(12.0)
                                    .padding(.bottom, 10)
                                
                            }
                        }
                        
                        NavigationLink(destination: TreeSelectionView())
                        {
                            Text("Adopt more trees")
                                .bold()
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                        .background(Color.init("color_primary_accent"))
                        .cornerRadius(10.0)
                        .padding()
                    }
                    .padding()
                }
            } else {
                GuestHomeView()
            }
        }
    }
}

struct TreeHeader: View {
    @ObservedObject var treeViewModel: TreeViewModel
    @State private var isActive = false
    @State private var navigateTo: AnyView = AnyView(EmptyView())
    let tree: Tree

    var body: some View {
        //tree header
        HStack {
      
            if let treeColor = tree.assignedTree?.tree_color {
                Image("pine-tree")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .leading)
                    .foregroundColor(Color.init(UIColor.init(hex: treeColor) ?? UIColor.init(Color.init("color_primary_accent"))))
            }
            
            VStack (alignment: .leading) {
                if let tree = tree.assignedTree {
                    if let treeName = tree.tree_name {
                        Text(treeName.isEmpty ? "Tree" : treeName)
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                    }
                    Text(showAdoptedDate())
                        .font(.caption)
                        .foregroundColor(.init("color_font_secondary"))
                    Text(showRemainingAdoptionPeriodDate())
                        .font(.caption)
                        .allowsTightening(true)
                        .foregroundColor(.init("color_font_secondary"))
                }
            }
            
            Spacer()
            
            Menu {
                Button(action: {
                    self.navigateTo = AnyView(TreePersonalizationView(treeViewModel: treeViewModel, tree: tree))
                    self.isActive = true
                }, label: {
                    Label(
                        title: { Text("Edit tree") },
                        icon: { Image(systemName: "square.and.pencil") })
                })

                Button(action: {
                    self.navigateTo = AnyView(PersonalSignView(treeViewModel: treeViewModel, tree: tree))
                    self.isActive = true
                }, label: {
                    Label(
                        title: { Text("Add sign") },
                        icon: { Image(systemName: "plus") })
                })

                Button(action: {actionSheet()}, label: {
                    Label(
                        title: { Text("Share your tree") },
                        icon: { Image(systemName: "square.and.arrow.up") })
                })
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.init("color_font_secondary"))
            }
            .frame(width: .none, height: 80, alignment: .topTrailing)
            .offset(x: 15, y: 0)
            .background(
                NavigationLink(destination: self.navigateTo, isActive: $isActive) {
                    EmptyView()
                })
        }
        .padding(.bottom)
    }
    
    
}

extension TreeHeader {
    
    func actionSheet() {
        guard let data = URL(string: "https://www.apple.nl") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func calculateTreeAge() -> DateComponents {

        if let tree = tree.assignedTree {
            return Calendar.current.dateComponents([.year, .day], from: tree.created_at, to: Date())
        }
        return DateComponents()
    }
    
    func calculateRemainingAdoptionPeriod() -> DateComponents {
        
        if let tree = tree.assignedTree {
            return Calendar.current.dateComponents([.day], from: tree.created_at, to: tree.expire_date)
        }
        return DateComponents()
    }
    
    func showAdoptedDate() -> String {
        var text = ""
        
        if let year = calculateTreeAge().year {
            text = "Adopted \(year) \(year > 1 ? "years" : "year") and "
            if year < 1 {
                text = "Adopted "
            }
        }
        
        if let day = calculateTreeAge().day {
            text += "\(day) \(day > 1 ? "days" : "day") ago"
        }
        return text
    }
    
    func showRemainingAdoptionPeriodDate() -> String {
        var text = ""
        
        if let day = calculateRemainingAdoptionPeriod().day {
            text = "Adoption period ends in \(day) \(day > 1 ? "days" : "day")"
        }
        return text
    }
    
}


