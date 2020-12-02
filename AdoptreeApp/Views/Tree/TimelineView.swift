//
//  TimelineView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TimelineView: View {
    //@State var respts: [Reportt] = []
    //@State var dic: [(DateComponents, [Episode])] = []
    
    var dict: [Int64:TimelineTree] = [1:TimelineTree(treeColor: Color.green, adoptedDate: Date(timeIntervalSince1970: 1111795200)), 2:TimelineTree(treeColor: Color.black, adoptedDate: Date(timeIntervalSince1970: 1112400000))]
    
    var episodes = [Episode(title: "Rose", airDate: Date(timeIntervalSince1970: 1111795200)),
                    Episode(title: "The Unquiet Dead", airDate: Date(timeIntervalSince1970: 1113004800)),
                    Episode(title: "The Long Game", airDate: Date(timeIntervalSince1970: 1115424000)),
                    Episode(title: "The End of the World", airDate: Date(timeIntervalSince1970: 1112400000))
    ]
    
    var telemetry = [
        Telemetry(id: 1, treeId: 1, reports: [Report(reportedOn: Date(timeIntervalSince1970: 1111795200), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1113004800), temperature: 23, humidity: 80, treeLength: 20, treeDiameter: 20)]),
        Telemetry(id: 2, treeId: 2, reports: [Report(reportedOn: Date(timeIntervalSince1970: 1112400000), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1115424000), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)])
    ]
    
    //    func item(val:) -> Date {
    //
    //    }
    
    func getsgg() -> AnyView {
        
        //        let empty: [Date: [Episode]] = [:]
        //        let groupedByDate = episodes.reduce(into: empty) { acc, cur in
        //            let components = Calendar.current.dateComponents([.year, .month], from: cur.airDate)
        //            let date = Calendar.current.date(from: components)!
        //            let existing = acc[date] ?? []
        //            acc[date] = existing + [cur]
        //        }
        //print(groupedByDate)
        
        //        let sortedUsers = episodes.sorted {
        //            $0.airDate < $1.airDate
        //        }
        //print(sortedUsers)
        //        let groupedItems = Dictionary(grouping: telemetry, by: {Calendar.current.dateComponents([.year, .month], from: $0.reports[$1].reportedOn)}).sorted(by: {$0.key.month! > $1.key.month!})
        
        // let groupedItems = Dictionary(grouping: telemetry, by: {Calendar.current.dateComponents([.year, .month], from: )}) //.sorted(by: {$0.key.month! > $1.key.month!})
        
        //        let aas = telemetry
        //            .flatMap({ te in
        //                te.reports.map({ re in
        //                    return Reportt(treeId: te.treeId, reportedOn: re.reportedOn, temperature: re.temperature, humidity: re.humidity, treeLength: re.treeLength, treeDiameter: re.treeDiameter)
        //                })
        //            })
        
        var resports:[Reportt] = []
        telemetry.forEach({ te in
            te.reports.forEach({ re in
                resports.append(Reportt(treeId: te.treeId, reportedOn: re.reportedOn, temperature: re.temperature, humidity: re.humidity, treeLength: re.treeLength, treeDiameter: re.treeDiameter))
            })
        })
        
        let grouping = Dictionary(grouping: resports, by: {Calendar.current.dateComponents([.year, .month], from: $0.reportedOn)}).sorted(by: {$0.key.month! > $1.key.month!})
        print(grouping)
        
        //        let groupedItems = Dictionary(grouping: telemetry, by: {item -> DateComponents in
        //            let add = DateComponents()
        //            for i in item.reports {
        //                //return i.reportedOn
        //                return Calendar.current.dateComponents([.year, .month], from: i.reportedOn)
        //            }
        //            return add
        //            //return DateComponents()
        //        })
        //        print(groupedItems)
        //let groupedItems = Dictionary(grouping: telemetry, by: {$0.treeId}).sorted(by: {$0.key > $1.key})
        //            .map { (arg: (key: Int, rawSections: [Telemetry])) -> Group<Any> in
        //
        //            }
        
        // self.dic = dic.sorted(by: {$0.key.month! > $1.key.month!})
        //print(groupedItems[0])
        
        
        //                for (key, value) in groupedItems.enumerated() {
        //                    //print("Dictionary key \(key) - Dictionary value \(value.key.month)")
        //
        //                    //convert date to month name
        //                    let now = Calendar.current.date(from: value.key)!
        //                    let dateFormatter = DateFormatter()
        //                    dateFormatter.dateFormat = "LLLL YYYY"
        //                    let nameOfMonth = dateFormatter.string(from: now)
        //                    print(nameOfMonth)
        //
        //                    //TimelineCell(date: "5th", title: "result", icon: Image(systemName: "eye.fill"))
        //                }
        
        return AnyView(
            VStack {
                ForEach(Array(zip(grouping.indices, grouping.enumerated())), id: \.0) { index, tree in
                    
                    //tree[index].
                    Text("\(vasds(date: tree.element.key))")
                    
                    ForEach(Array(zip(tree.element.value.indices, tree.element.value)), id: \.0) { index, trss in
                        // TimelineCell(date: "5th", title: "result", icon: Image(systemName: "eye.fill"))
                        
                        TimelineCell(date: "\(getDay(date: trss.reportedOn))", title: "Weekly result", icon: Image(systemName: "eye.fill"), treeColor: getColor(color: trss.treeId))
                    }
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
                        .padding()
                }
            }
        )
    }
    
    func getColor(color:Int64) -> Color {
        return dict[color]?.treeColor ?? Color.green
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
    
    func vasds(date: DateComponents) -> String {
        //convert date to month name
        let now = Calendar.current.date(from: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        return dateFormatter.string(from: now)
    }
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    getsgg()
                    //                    ForEach(dic.indices) { index in
                    //                        Text("\(self.dic[index])")
                    //
                    //                    }
                    
                    //                    ForEach(Array(dic.keys.enumerated()), id:\.element) { _, key in
                    //                        Text("TBD \(self.dic[key])")
                    //                        // Will be putting checkboxes here - i.e. so can chose which ones
                    //                    }
                    
                    
                    //                    TimelineCell(date: "5th", title: "result", icon: Image(systemName: "eye.fill"))
                    //                    TimelineCell(date: "5th", title: "result", icon: Image(systemName: "eye.fill"))
                    //                    TimelineCell(date: "5th", title: "result", icon: Image(systemName: "eye.fill"))
                    
                    
                    
                }
            }
        }
    }
}
struct Episode {
    let title: String
    let airDate: Date
}

struct TimelineCell: View {
    let date: String
    let title: String
    let icon: Image?
    var treeColor: Color = Color.green
    
    var body: some View {
        
        //        RoundedRectangle(cornerRadius: 12.0)
        //            .fill(Color.white)
        //            .frame(width: UIScreen.main.bounds.width * 0.8, height: .nan, alignment: .leading)
        //            .overlay(
        HStack{
            HStack {
                //                Path { path in
                //                    path.move(to: CGPoint(x: 20, y: 0))
                //                    path.addLine(to: CGPoint(x: 10, y: 0))
                //
                //                }.stroke(Color.black, lineWidth: 2)
                
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
                    icon
                    //.resizable()
                    //.frame(width: 30, height: 30)
                }
                
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width * 0.8, height: .none, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12.0)
            
        }
        
        
        //                .padding(10))
        //            .padding(.bottom, 5)
    }
}

//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView()
//    }
//}

