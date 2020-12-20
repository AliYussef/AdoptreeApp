//
//  TimelineView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var timelineViewModel: TimelineViewModel
    @ObservedObject var treeViewModel: TreeViewModel
    @State private var selectedTree = 0
    @State private var selectedDate = 0
    @State private var selectedTreeLabel = ""
    @State private var selectedDateLabel = ""
    
//    var sequestrationsMock: [Sequestration]? = [Sequestration(treeId: 1, sequestration: [0.989273]), Sequestration(treeId: 2, sequestration: [0.989273, 0.7126873])]
//
//    var telemetries = [
//        Telemetry(id: "1", treeId: "1", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1606828056), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1605186555), temperature: 23, humidity: 80, treeLength: 20, treeDiameter: 20)]),
//        Telemetry(id: "2", treeId: "2", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1602508155), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1607778456), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)])
//    ]
    
    var images = [
        TreeImage(tree_id: 1, images: [ImageDetail(id: 1, tree_id: 1, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1606828056))]),
        TreeImage(tree_id: 2, images: [ImageDetail(id: 2, tree_id: 2, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1605186555))])
    ]
    
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
                            if !timelineViewModel.telemetries.isEmpty {
                                generateTimelineCellViews()
                            } else {
                                ProgressView("Loading timeline...")
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

        var reports:[Timeline] = []
        if !timelineViewModel.timelineTreeDic.isEmpty {
            timelineViewModel.telemetries.forEach({ telemetry in
                var index = 0
                telemetry.reports.forEach({ report in
                    if index < (timelineViewModel.sequestrations.filter({$0.treeId == Int64(telemetry.treeId)}).first?.sequestration.count)! {
                        
                        reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: "report", reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: timelineViewModel.sequestrations.filter({$0.treeId == Int64(telemetry.treeId)}).first?.sequestration[index], image_blobname: nil))
                        
                    } else {
                        reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: "report", reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: nil, image_blobname: nil))
                    }
                    
                    //timelineViewModel.datesFilter.append(Calendar.current.dateComponents([.year], from: report.reportedOn))
                    
                    index += 1
                })
//                if let adoptedDate = timelineViewModel.timelineTreeDic[Int64(telemetry.treeId)!]?.adoptedDate {
//                    reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: "tree", reportedOn: adoptedDate, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: nil))
//                }
                
            })
            
            timelineViewModel.timelineTreeDic.forEach({ tree in
                reports.append(Timeline(treeId: tree.key, type: "tree", reportedOn: tree.value.adoptedDate, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: nil))
            })
        }
        
        
        images.forEach({ image in
            image.images.forEach({ imageDetail in
                reports.append(Timeline(treeId: imageDetail.tree_id, type: "image", reportedOn: imageDetail.createdAt, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: imageDetail.image_blobname))
            })
        })
        
        let timelineFirstGrouping = Dictionary(grouping: reports, by: {Calendar.current.dateComponents([.year, .month], from: $0.reportedOn)}).sorted(by: {($0.key.year! > $1.key.year!)})
        let timelineGrouping = timelineFirstGrouping.sorted(by: {($0.key.month! > $1.key.month!) && ($0.key.year! > $1.key.year!)})
        // {($0.key.year! > $1.key.year!) && ($0.key.month! > $1.key.month!)}
        //        timelineGrouping.filter({
        //            if selectedDate > 0 {
        //                return $0.key.year! == timelineViewModel.datesFilter[selectedDate].year
        //            }
        //
        //            return true
        //        })
        //print(timelineGrouping)
        let reportsSorted = reports.sorted(by: {$0.reportedOn > $1.reportedOn})
        return AnyView(
            VStack {
//                ForEach(Array(zip(timelineGrouping.indices, timelineGrouping.filter({
//                    if selectedDate > 0 {
//                        return $0.key.year! == timelineViewModel.datesFilter[selectedDate].year
//                    }
//
//                    return true
//                }).enumerated())), id: \.0) { index, tree in
//
//                    Text("\(getHumanReadableDate(date: tree.element.key))")
//
//                    ForEach(Array(zip(tree.element.value.indices, tree.element.value.filter({
//                        if selectedTree > 0 {
//                            return $0.treeId == timelineViewModel.treeTypeFilter[selectedTree].treeId
//                        }
//                        return true
//                    }))), id: \.0) { index, item in
//
//                        if item.type == "report" {
//                            TimelineCell(item: item, date: "\(getDay(date: item.reportedOn))", title: "Weekly result", icon: Image(systemName: "eye.fill"), treeColor: getTreeColor(treeId: item.treeId))
//                        } else if item.type == "tree" {
//                            TimelineCell(item: item, date: "\(getDay(date: item.reportedOn))", title: "Adopted \(timelineViewModel.timelineTreeDic[item.treeId]?.treeName ?? "Tree")", icon: Image(systemName: "heart.fill"), treeColor: getTreeColor(treeId: item.treeId))
//                        } else if item.type == "image" {
//                            TimelineCell(item: item, date: "\(getDay(date: item.reportedOn))", title: "New tree image", icon: Image(systemName: "photo"), treeColor: getTreeColor(treeId: item.treeId))
//                        }
//
//                    }
//                    Divider()
//                        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
//                        .padding()
//                }
                
//                var currentDate = Date()
//                var nextDate = Date()
                
               
                ForEach(Array(reportsSorted.filter({
                    if selectedDate > 0 {
                        return Calendar.current.dateComponents([.year], from: $0.reportedOn).year == timelineViewModel.datesFilter[selectedDate].year
                    }
                    if selectedTree > 0 {
                        return $0.treeId == timelineViewModel.treeTypeFilter[selectedTree].treeId
                    }
                    
                    return true
                }).enumerated()), id: \.1.id){ index, report in
                    //var currentDate = report.reportedOn
                    
                    if index > 0 {
                        if Calendar.current.dateComponents([.year, .month], from: report.reportedOn) != Calendar.current.dateComponents([.year, .month], from: reportsSorted[index - 1].reportedOn) {
                            Text("\(getHumanReadableDate(date: report.reportedOn))")
                                .padding(.top)
                        }
                    } else {
                        Text("\(getHumanReadableDate(date: report.reportedOn))")
                            .padding(.top)
                    }
                    
                    if report.type == "report" {
                        TimelineCell(item: report, date: "\(getDay(date: report.reportedOn))", title: "Weekly result", icon: Image(systemName: "eye.fill"), treeColor: getTreeColor(treeId: report.treeId))
                    } else if report.type == "tree" {
                        TimelineCell(item: report, date: "\(getDay(date: report.reportedOn))", title: "Adopted \(timelineViewModel.timelineTreeDic[report.treeId]?.treeName ?? "Tree")", icon: Image(systemName: "heart.fill"), treeColor: getTreeColor(treeId: report.treeId))
                    } else if report.type == "image" {
                        TimelineCell(item: report, date: "\(getDay(date: report.reportedOn))", title: "New tree image", icon: Image(systemName: "photo"), treeColor: getTreeColor(treeId: report.treeId))
                    }
                    
                    
                }
                
            }
        )
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
                        if item.type != "tree" {
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
                if item.type == "report" {
                    TreeDataSectionTimeline(item: item)
                } else if item.type == "image" {
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
