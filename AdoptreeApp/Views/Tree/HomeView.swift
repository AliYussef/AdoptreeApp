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
    @EnvironmentObject var treeViewModel: TreeViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    var body: some View {
        
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            if userViewModel.isAuthenticated {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if treeViewModel.trees.isEmpty {
                            if treeViewModel.isThereAgoptedTrees {
                                ProgressView("Loading your trees...")
                            } else {
                                VStack {
                                    Text("Your adopted trees have not been planted yet. Once they are planted you will be able to monitor their status.")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 20, height: .none)
                                .background(Color.white)
                                .cornerRadius(12.0)
                                .padding(.bottom, 10)
                            }
                        } else {
                            
                            TotalCo2Redcution()
                            
                            if !treeViewModel.isExpanded.isEmpty {
                                ForEach(Array(zip(treeViewModel.trees.indices, treeViewModel.trees)), id: \.0) { index, tree in
                                    
                                    DisclosureGroup(
                                        isExpanded: $treeViewModel.isExpanded[index],
                                        content: {
                                            if let treeId = tree.assignedTree?.tree_id {
                                                TreeView(tree: tree, telemetry: timelineViewModel.telemetries.filter({Int64($0.treeId)! == treeId}).first?.reports.first ?? nil, sequestration: timelineViewModel.sequestrations.filter({$0.treeId == treeId}).first?.sequestration, treeImage: treeViewModel.treeImages.filter({$0.tree_id == treeId}).first, wildlife: treeViewModel.wildlifes.filter({$0.forestId == tree.forestId}).first?.wildlife)
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

struct TotalCo2Redcution: View {
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Total CO2 Reduced")
                .font(.title3)
                .multilineTextAlignment(.leading)
                .foregroundColor(.init("color_font_primary"))
            
            HStack {
                Image("co2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                
                Text("\(String(format: "%.4f", calculateTotalSequestrations()))kg")
                    .font(.title)
                    .bold()
                    .foregroundColor(.init("color_font_primary"))
                    .padding(.bottom, 30)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 20, height: .none)
        .background(Color.white)
        .cornerRadius(12.0)
        .padding(.bottom, 10)
    }
}

extension TotalCo2Redcution {
    
    func calculateTotalSequestrations() -> Double {
        var result = 0.0
        
        timelineViewModel.sequestrations.forEach({ sequestration in
            result += sequestration.sequestration.reduce(0, +)
        })
        
        let totalInGrams = Measurement(value: result, unit: UnitMass.grams)
        return totalInGrams.converted(to: .kilograms).value
    }
}

struct TreeHeader: View {
    @ObservedObject var treeViewModel: TreeViewModel
    @State private var isActive = false
    @State private var navigateTo: AnyView = AnyView(EmptyView())
    let tree: Tree
    
    var body: some View {
      
        HStack {
            
            Image("tree")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70, alignment: .leading)
                .foregroundColor(Color.init(UIColor.init(hex: tree.assignedTree?.tree_color ?? "#87B62C") ?? UIColor.init(Color.init("color_primary_accent"))))
            
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
                    self.navigateTo = AnyView(TreePersonalizationView(tree: tree))
                    self.isActive = true
                }, label: {
                    Label(
                        title: { Text("Edit tree") },
                        icon: { Image(systemName: "square.and.pencil") })
                })
                
                Button(action: {
                    self.navigateTo = AnyView(PersonalSignView(tree: tree))
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
            //if tree.created_at == tree.expire_date {
                let timeInterval = DateComponents(year: 1)
                let expiredDate = Calendar.current.date(byAdding: timeInterval, to: tree.created_at)
                if let expiredDate = expiredDate {
                    return Calendar.current.dateComponents([.day], from: tree.created_at, to: expiredDate)
                }
           // }
            //return Calendar.current.dateComponents([.day], from: tree.created_at, to: tree.expire_date)
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


