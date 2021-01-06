//
//  TimelineView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    @State private var selectedTree = 0
    @State private var selectedDate = 0
    @State private var selectedTreeLabel = ""
    @State private var selectedDateLabel = ""
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            if userViewModel.isAuthenticated {
                VStack {
                    HStack {
                        Spacer()
                        
                        if timelineViewModel.areFiltersDataReady {
                            Picker(selection: $selectedTree, label: Label(
                                title: { Text("\(selectedTreeLabel.isEmpty ? "Tree" : selectedTreeLabel)").foregroundColor(.black) },
                                icon: { Image(systemName: "arrowtriangle.down.fill") }
                            )) {
                                ForEach(0 ..< timelineViewModel.treeTypeFilter.count) {
                                    Text("\(self.timelineViewModel.treeTypeFilter[$0].treeName)")
                                }
                            }
                            .onChange(of: selectedTree, perform: { value in
                                selectedTreeLabel = timelineViewModel.treeTypeFilter[value].treeName
                            })
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: 40)
                            .background(Color.white)
                            .cornerRadius(12.0)
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            
                            Picker(selection: $selectedDate, label: Label(
                                title: { Text("\(selectedDateLabel.isEmpty ? "Date" : selectedDateLabel)").foregroundColor(.black) },
                                icon: { Image(systemName: "arrowtriangle.down.fill") }
                            )) {
                                
                                ForEach(0 ..< timelineViewModel.datesFilter.count) {
                                    if getHumanReadableYear(date: self.timelineViewModel.datesFilter[$0]) == "0001" {
                                        Text("All")
                                    } else {
                                        Text(getHumanReadableYear(date: self.timelineViewModel.datesFilter[$0]))
                                    }
                                }
                            }
                            .onChange(of: selectedDate, perform: { value in
                                if let year = timelineViewModel.datesFilter[value].year {
                                    selectedDateLabel = String(year)
                                } else {
                                    selectedDateLabel = "All"
                                }
                            })
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: 40)
                            .background(Color.white)
                            .cornerRadius(12.0)
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        }
                        
                        Spacer()
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            if !timelineViewModel.reports.isEmpty {
                                
                                ForEach(Array(timelineViewModel.reports.filter({
                                    if selectedDate > 0 {
                                        return Calendar.current.dateComponents([.year], from: $0.reportedOn).year == timelineViewModel.datesFilter[selectedDate].year
                                    }
                                    if selectedTree > 0 {
                                        return $0.treeId == timelineViewModel.treeTypeFilter[selectedTree].treeId
                                    }
                                    
                                    return true
                                }).enumerated()), id: \.1.id){ index, report in
                                    
                                    if index > 0 {
                                        if Calendar.current.dateComponents([.year, .month], from: report.reportedOn) != Calendar.current.dateComponents([.year, .month], from: timelineViewModel.reports[index - 1].reportedOn) {
                                            Text("\(getHumanReadableDate(date: report.reportedOn))")
                                                .padding(.top)
                                        }
                                    } else {
                                        Text("\(getHumanReadableDate(date: report.reportedOn))")
                                            .padding(.top)
                                    }
                                    
                                    if report.type == TimelineEntryType.report {
                                        TimelineCell(item: report, date: "\(getDay(date: report.reportedOn))", title: "Weekly result", icon: Image(systemName: "eye.fill"), treeColor: getTreeColor(treeId: report.treeId))
                                    } else if report.type == TimelineEntryType.tree {
                                        TimelineCell(item: report, date: "\(getDay(date: report.reportedOn))", title: "Adopted \(timelineViewModel.timelineTreeDic[report.treeId]?.treeName ?? "Tree")", icon: Image(systemName: "heart.fill"), treeColor: getTreeColor(treeId: report.treeId))
                                    } else if report.type == TimelineEntryType.image {
                                        TimelineCell(item: report, date: "\(getDay(date: report.reportedOn))", title: "New tree image", icon: Image(systemName: "photo"), treeColor: getTreeColor(treeId: report.treeId))
                                    }
                                    
                                    
                                }
                            } else {
                                if treeViewModel.isThereAgoptedTrees {
                                    ProgressView("Loading timeline...")
                                    generateTimelineCellViews()
                                } else {
                                    VStack {
                                        Text("Your adopted trees have not been planted yet. Once they are planted you will be able to follow their storis.")
                                            .font(.body)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width - 20, height: .none)
                                    .background(Color.white)
                                    .cornerRadius(12.0)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }
                .padding()
            } else {
                GuestTimelineView()
            }
            
        }
    }
}

extension TimelineView {
    
    func generateTimelineCellViews() -> AnyView {
        
        if !timelineViewModel.telemetries.isEmpty {
            timelineViewModel.createTimelineTreeObject(trees: treeViewModel.trees)
            timelineViewModel.createTimelineDateFilter(trees: treeViewModel.trees)
        }
        
        if !timelineViewModel.telemetries.isEmpty && !timelineViewModel.sequestrations.isEmpty {
            timelineViewModel.generateTimelineData(images: nil)
        }
       
        return AnyView(EmptyView())
    }
    
    func getHumanReadableDate(date: Date) -> String {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let extractedDate = Calendar.current.date(from: dateComponents)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        return dateFormatter.string(from: extractedDate)
    }
    
    func getHumanReadableYear(date: DateComponents) -> String {
        let extractedDate = Calendar.current.date(from: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: extractedDate)
    }
    
    func getDay(date: Date) -> String {
        
        let anchorComponents = Calendar.current.dateComponents([.day], from: date)
        var day  = "\(anchorComponents.day!)"
        switch (day) {
            case "1" , "21" , "31":
                day.append("st")
            case "2" , "22":
                day.append("nd")
            case "3" ,"23":
                day.append("rd")
            default:
                day.append("th")
        }
        return day
    }
    
    func getTreeColor(treeId: Int64) -> Color {
        if let treeColor = timelineViewModel.timelineTreeDic[treeId]?.treeColor {
            if let color = UIColor(hex: treeColor) {
                return Color(color)
            }
        }
        return Color.init("color_primary_accent")
    }
    
}

struct TimelineCell: View {
    let item: Timeline
    let date: String
    let title: String
    let icon: Image?
    var treeColor: Color
    @State var isPresented = false
    
    var body: some View {
        
        HStack{
            HStack {
                Circle()
                    .fill(treeColor)
                    .frame(width: 15, height: 15)
            }
            
            HStack(alignment: .center) {
                Text(date)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.init("color_font_secondary"))
                
                Text(title)
                    .font(.title3)
                    .foregroundColor(.init("color_font_primary"))
                
                Spacer()
                
                if let icon = icon {
                    Button(action: {
                        if item.type != TimelineEntryType.tree {
                            self.isPresented.toggle()
                        }
                    }, label: {
                        icon
                            .foregroundColor(.black)
                    })
                    .sheet(isPresented: $isPresented) {
                        TimelineDetailView(isPresented: $isPresented, item: item)
                    }
                }
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width * 0.8, height: .none, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12.0)
            
        }
    }
}

struct TimelineDetailView: View {
    @Binding var isPresented: Bool
    let item: Timeline
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if item.type == TimelineEntryType.report {
                    TreeDataSectionTimeline(item: item)
                } else if item.type == TimelineEntryType.image  {
                    Image("gree_idea_header")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width, height: .none)
                }
            }
        }
    }
}

struct TreeDataSectionTimeline: View {
    let item: Timeline
    
    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                .overlay(
                    VStack(alignment: .center)  {
                        Text("CO2 Reduction")
                            .font(.title3)
                            .foregroundColor(Color.init("color_font_primary"))
                            .padding(.bottom, 30)
                        
                        Text("\(String(format: "%.4f", getSequestration()))kg")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.init("color_font_primary"))
                            .padding(.bottom, 50)})
            
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.init("color_primary_accent"))
                .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                .overlay(
                    VStack(alignment: .center)  {
                        Text("Growth")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 30)
                        
                        if let treeLength = item.treeLength {
                            Text("\(treeLength)cm")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 50)}
                    })
                
                .offset(x: 0, y: 0)
        }
        HStack() {
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                .overlay(
                    VStack(alignment: .center)  {
                        Text("Temperature")
                            .font(.title3)
                            .foregroundColor(Color.init("color_font_primary"))
                        
                        ZStack {
                            Circle()
                                .stroke(temperatureColor, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                                .frame(width: 100, height: 100, alignment: .center)
                                .padding(.bottom, 20)
                            
                            if let temperature = item.temperature {
                                Text("\(temperature) °")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.init("color_font_primary"))
                                    .padding(.bottom, 20)
                            }
                            
                        }
                    })
            
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color.init("color_blue"))
                .frame(width: UIScreen.main.bounds.width * 0.43, height: 170, alignment: .center)
                .overlay(
                    VStack(alignment: .center)  {
                        Text("Humidity")
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 30)
                        
                        if let humidity = item.humidity {
                            Text("\(humidity)%")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 50)
                        }
                    })
                .offset(x: 0, y: 0)
        }
    }
}

extension TreeDataSectionTimeline {
    
    var temperatureColor : Color {
        if let temperature = item.temperature {
            if temperature <= 0 {
                return Color.init("color_blue")
            }else if temperature > 0 && temperature <= 10 {
                return Color.init("color_primary_accent")
            }else if temperature > 10 && temperature <= 20 {
                return Color.yellow
            }else if temperature > 20 && temperature <= 30 {
                return Color.orange
            }
        }
        return Color.red
    }
    
    func getSequestration() -> Double {
        if let sequestration = item.sequestration {
            let resultInGrams = Measurement(value: sequestration, unit: UnitMass.grams)
            return resultInGrams.converted(to: .kilograms).value
        }
        return 0
    }
}
