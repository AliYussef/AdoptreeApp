//
//  HomeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @ObservedObject var treeViewModel: TreeViewModel
    @State private var isExpanded: [Bool] = [true]
    
    var sequestrations = [0.989273, 0.7126873, 0.827817, 0.2812727]
    var wildlife = [Wildlife(id: 1, name: "Eurasian red squirrel", description: "Eurasian red squirrel"), Wildlife(id: 2, name: "Red squirrel", description: "Eurasian red squirrel"), Wildlife(id: 3, name: "Eurasian", description: "Eurasian red squirrel")]
    var images = TreeImage(tree_id: 1, images: [ImageDetail(id: 1, tree_id: 1, image_blobname: "", alt: "", createdAt: ""), ImageDetail(id: 2, tree_id: 1, image_blobname: "", alt: "", createdAt: "")])
    
    var telemetry = [
        Telemetry(id: 1, treeId: 1, reports: [Report(reportedOn: Date(timeIntervalSince1970: 1111795200), temperature: -3, humidity: 90, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1113004800), temperature: 23, humidity: 80, treeLength: 20, treeDiameter: 20)]),
        Telemetry(id: 2, treeId: 2, reports: [Report(reportedOn: Date(timeIntervalSince1970: 1112400000), temperature: 22, humidity: 80, treeLength: 22, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1115424000), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)])
    ]
    
    var body: some View {
        
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.bottom)
            
            ScrollView {
                
                VStack {
                    if treeViewModel.trees.isEmpty {
                        ProgressView("Loading your trees...")
                        //                            .onAppear {
                        //                                userViewModel.getAdoptedTrees() {_ in}
                        //                            }
                        
                    } else {
                        //initializeExpandedList()
                        // ForEach(isExpanded.indices) { position in
                        ForEach(Array(zip(treeViewModel.trees.indices, treeViewModel.trees)), id: \.0) { index, tree in
                            
                            DisclosureGroup(
                                isExpanded: $treeViewModel.isExpanded[index],
                                content: {
                                    if let treeId = tree.assignedTree?.tree_id {
                                        TreeView(tree: tree, telemetry: telemetry.filter({$0.treeId == treeId}).first?.reports.first ?? nil, sequestration: sequestrations, treeImage: images, wildlife: wildlife)
                                    }
                                },
                                label: {
                                    
                                    TreeHeader(tree: tree)
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
            
        }
    }
}

struct TreeHeader: View {
    let tree: Tree
    @State private var isActive = false
    @State private var navigateTo: AnyView = AnyView(EmptyView())
    @State var showingDetail = false
    @State var showingDetaill = false
    
    var body: some View {
        //tree header
        HStack {
            //#87B62C
            if let treeColor = tree.assignedTree?.tree_color {
                Image("pine-tree")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .leading)
                    .foregroundColor(Color.init(UIColor.init(hex: treeColor) ?? UIColor.init(Color.init("color_primary_accent"))))
                //Text("\(UIColor(Color.red).cgColor)")
            }
            
            VStack (alignment: .leading) {
                if let tree = tree.assignedTree {
                    if let treeName = tree.tree_name {
                        Text(treeName.isEmpty ? "Tree" : treeName)
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                    }
                    Text(showAdoptedDate())
                        //Text("Adopted\(DateFormatter().string(from: tree.created_at))ago")
                        //Text(tree.assignedTree!.created_at)
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
                   self.navigateTo = AnyView(TreePersonalizationView())
                    self.isActive = true
                   // self.showingDetail.toggle()
                }, label: {
                    Label(
                        title: { Text("Edit tree") },
                        icon: { Image(systemName: "square.and.pencil") })
                })
//                .sheet(isPresented: $showingDetail) {
//                    TreePersonalizationView(shown: self.$showingDetail)
//                }
                
                
                Button(action: {
                    self.navigateTo = AnyView(PersonalSignView())
                    self.isActive = true
                    //self.showingDetaill.toggle()
                }, label: {
                    Label(
                        title: { Text("Add sign") },
                        icon: { Image(systemName: "plus") })
                })
//                .sheet(isPresented: $showingDetaill) {
//                    PersonalSignView(shown: self.$showingDetaill)
//                }
                
                
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
//            .sheet(isPresented: $showingDetail) {
//                self.navigateTo
//            }
            .background(
                NavigationLink(destination: self.navigateTo, isActive: $isActive) {
                    EmptyView()
                })
//
        }
        .padding(.bottom)
    }
    
    
}

extension TreeHeader {
    
    func actionSheet() {
        guard let data = URL(string: "Tree") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func calculateTreeAge() -> DateComponents {
        // let age: DateComponents
        
        if let tree = tree.assignedTree {
            return Calendar.current.dateComponents([.year, .day], from: tree.created_at, to: Date())
            //        let age = Calendar.current.dateComponents([.year, .day], from: Date(timeIntervalSince1970: 1115424000), to: Date())
        }
        return DateComponents()
        // return age
    }
    
    func calculateRemainingAdoptionPeriod() -> DateComponents {
        //let remainingTime: DateComponents
        
        if let tree = tree.assignedTree {
            return Calendar.current.dateComponents([.day], from: tree.created_at, to: tree.expire_date)
        }
        
        return DateComponents()
        //return remainingTime
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

//struct Collapsible<Content: View>: View {
//    @State var label: () -> Text
//    @State var content: () -> Content
//
//    @State private var collapsed: Bool = true
//
//    var body: some View {
//        VStack {
//            Button(
//                action: { self.collapsed.toggle() },
//                label: {
//                    HStack {
//                        self.label()
//                        Spacer()
//                        Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
//                    }
//                    .padding(.bottom, 1)
//                    .background(Color.white.opacity(0.01))
//                }
//            )
//            //.buttonStyle(PlainButtonStyle())
//
//
//            VStack {
//                self.content()
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: self.collapsed ? 0 : .none)
//            .clipped()
//            .animation(.easeOut)
//            .transition(.slide)
//        }
//    }
//}

