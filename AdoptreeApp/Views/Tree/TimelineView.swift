//
//  TimelineView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TimelineView: View {
    @ObservedObject var timelineViewModel: TimelineViewModel
    
    var sequestrationsMock: [Sequestration]? = [Sequestration(treeId: 1, sequestration: [0.989273]), Sequestration(treeId: 2, sequestration: [0.989273, 0.7126873])]
    
    var telemetries = [
        Telemetry(id: 1, treeId: 1, reports: [Report(reportedOn: Date(timeIntervalSince1970: 1606828056), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1605186555), temperature: 23, humidity: 80, treeLength: 20, treeDiameter: 20)]),
        Telemetry(id: 2, treeId: 2, reports: [Report(reportedOn: Date(timeIntervalSince1970: 1602508155), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1607778456), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)])
    ]
    
    var images = [
        TreeImage(tree_id: 1, images: [ImageDetail(id: 1, tree_id: 1, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1606828056))]),
        TreeImage(tree_id: 2, images: [ImageDetail(id: 2, tree_id: 2, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1605186555))])
    ]
    
    var strengths = ["Mild", "Medium", "Mature"]
    
//    let trees = [
//        Tree(id: 1, forestId: 1, productId: 1, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 1, order_id: 1, created_at: Date(timeIntervalSince1970: 1604236155), expire_date: Date(timeIntervalSince1970: 1112400000), tree_name: "White oak", tree_color: "#9DA536FF"), latitude: "", longitude: ""),
//
//        Tree(id: 2, forestId: 2, productId: 2, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 2, order_id: 2, created_at: Date(timeIntervalSince1970: 1601557755), expire_date: Date(timeIntervalSince1970: 1115424000), tree_name: "Tree", tree_color: "#3655a5"), latitude: "", longitude: "")
//
//    ]
    
    @State private var selectedTree = 0
    @State private var selectedDate = 0
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Picker(selection: $selectedTree, label: Label(
                        title: { Text("Tree").foregroundColor(.black) },
                        icon: { Image(systemName: "arrowtriangle.down.fill") }
                    )) {
                        ForEach(0 ..< timelineViewModel.treeTypeFilter.count) {
                            Text("\(self.timelineViewModel.treeTypeFilter[$0].treeName)")
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 40)
                    .background(Color.white)
                    .cornerRadius(12.0)
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Picker(selection: $selectedDate, label: Label(
                        title: { Text("Date").foregroundColor(.black) },
                        icon: { Image(systemName: "arrowtriangle.down.fill") }
                    )) {
                        
                        ForEach(0 ..< timelineViewModel.datesFilter.count) {
                            if getHumanReadableDate2(date: self.timelineViewModel.datesFilter[$0]) == "0001" {
                                Text("All")
                            } else {
                                Text(getHumanReadableDate2(date: self.timelineViewModel.datesFilter[$0]))
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 40)
                    .background(Color.white)
                    .cornerRadius(12.0)
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        generateTimelineCellViews()
                    }
                }
            }
            .padding()
        }
    }
}

extension TimelineView {
    
    func generateTimelineCellViews() -> AnyView {
        
        var resports:[Timeline] = []
        telemetries.forEach({ telemetry in
            var index = 0
            telemetry.reports.forEach({ report in
                if index < (sequestrationsMock?.filter({$0.treeId == telemetry.treeId}).first?.sequestration.count)! {
                    
                    resports.append(Timeline(treeId: telemetry.treeId, type: "report", reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: sequestrationsMock?.filter({$0.treeId == telemetry.treeId}).first?.sequestration[index], image_blobname: nil))
                    
                } else {
                    resports.append(Timeline(treeId: telemetry.treeId, type: "report", reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: nil, image_blobname: nil))
                }
                
                timelineViewModel.datesFilter.append(Calendar.current.dateComponents([.year], from: report.reportedOn))
                
                index += 1
            })
            if let adoptedDate = timelineViewModel.timelineTreeDic[telemetry.treeId]?.adoptedDate {
                resports.append(Timeline(treeId: telemetry.treeId, type: "tree", reportedOn: adoptedDate, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: nil))
            }
        })
        
        images.forEach({ image in
            image.images.forEach({ imageDetail in
                resports.append(Timeline(treeId: imageDetail.tree_id, type: "image", reportedOn: imageDetail.createdAt, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: imageDetail.image_blobname))
            })
        })
        
        let timelineGrouping1 = Dictionary(grouping: resports, by: {Calendar.current.dateComponents([.year, .month], from: $0.reportedOn)}).sorted(by: {($0.key.year! > $1.key.year!)})
        let timelineGrouping = timelineGrouping1.sorted(by: {($0.key.month! > $1.key.month!) && ($0.key.year! > $1.key.year!)})
           // {($0.key.year! > $1.key.year!) && ($0.key.month! > $1.key.month!)}
//        timelineGrouping.filter({
//            if selectedDate > 0 {
//                return $0.key.year! == timelineViewModel.datesFilter[selectedDate].year
//            }
//
//            return true
//        })
        print(timelineGrouping)
        
        return AnyView(
            VStack {
                ForEach(Array(zip(timelineGrouping.indices, timelineGrouping.filter({
                    if selectedDate > 0 {
                        return $0.key.year! == timelineViewModel.datesFilter[selectedDate].year
                    }
                    
                    return true
                }).enumerated())), id: \.0) { index, tree in
                    
                    Text("\(getHumanReadableDate(date: tree.element.key))")
                    
                    ForEach(Array(zip(tree.element.value.indices, tree.element.value.filter({
                        if selectedTree > 0 {
                            return $0.treeId == timelineViewModel.treeTypeFilter[selectedTree].treeId
                        }
                        return true
                    }))), id: \.0) { index, item in
                        
                        if item.type == "report" {
                            TimelineCell(item: item, date: "\(getDay(date: item.reportedOn))", title: "Weekly result", icon: Image(systemName: "eye.fill"), treeColor: getTreeColor(treeId: item.treeId))
                        } else if item.type == "tree" {
                            TimelineCell(item: item, date: "\(getDay(date: item.reportedOn))", title: "Adopted \(timelineViewModel.timelineTreeDic[item.treeId]?.treeName ?? "Tree")", icon: Image(systemName: "heart.fill"), treeColor: getTreeColor(treeId: item.treeId))
                        } else if item.type == "image" {
                            TimelineCell(item: item, date: "\(getDay(date: item.reportedOn))", title: "New tree image", icon: Image(systemName: "photo"), treeColor: getTreeColor(treeId: item.treeId))
                        }
                        
                    }
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
                        .padding()
                }
            }
        )
    }
    
    func getHumanReadableDate(date: DateComponents) -> String {
        //convert date to month name
        let now = Calendar.current.date(from: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        return dateFormatter.string(from: now)
    }
    
    func getHumanReadableDate2(date: DateComponents) -> String {
        //convert date to month name
        let now = Calendar.current.date(from: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: now)
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
