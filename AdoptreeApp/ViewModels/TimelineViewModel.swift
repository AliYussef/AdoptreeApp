//
//  TimelineViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class TimelineViewModel: ObservableObject {
    @Published var reports: [Timeline] = []
    @Published var telemetries: [Telemetry] = []
    @Published var sequestrations: [Sequestration] = []
    @Published var timelineTreeDic: [Int64: TimelineTree] = [:]
    @Published var areFiltersDataReady: Bool = false
    var treeTypeFilter: [TimelineFilter] = []
    var datesFilter: [DateComponents] = []
    private let telemetryRepository: TelemetryRepositoryProtocol
    private let treeRepository: TreeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(telemetryRepository: TelemetryRepositoryProtocol, treeRepository: TreeRepositoryProtocol) {
        self.telemetryRepository = telemetryRepository
        self.treeRepository = treeRepository
    }
}
extension TimelineViewModel {
    
    func getTimeLineData(using treeId:Int64) {
        let telemetryUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .telemetryById(treeId), using: .get)
        let sequestrationUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .sequestration(treeId), using: .get)
        
        Publishers.Zip(telemetryRepository.getTelemetryByTree(using: telemetryUrlRequest), treeRepository.getTreeSequestraion(using: sequestrationUrlRequest))
            .sink(receiveValue: { telemetries, sequestrations in
               
                switch(telemetries) {
                    case .failure(let error):
                        print("telemetries")
                        switch error {
                            case .decodingError(let decodingError):
                                
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let telemetries):
                        //since the response is array but there is always one element only
                        //if let telemetry = telemetries.first {
                        if !self.telemetries.contains(where: {$0.treeId == telemetries.treeId}) {
                            self.telemetries.append(telemetries)
                        }
                        //}
                }
                
                switch(sequestrations) {
                    case .failure(let error):
                        print("sequestrations")
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let sequestrations):
                        if !self.sequestrations.contains(where: {$0.treeId == treeId}) {
                            self.sequestrations.append(Sequestration(treeId: treeId, sequestration: sequestrations))
                        }
                        
                }
            })
            .store(in: &cancellables)
    }
}

extension TimelineViewModel {
    
    func generateTimelineData(images: [TreeImage]?) {
        let images = [
            TreeImage(tree_id: 1, images: [ImageDetail(id: 1, tree_id: 1, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1606828056))]),
            TreeImage(tree_id: 2, images: [ImageDetail(id: 2, tree_id: 2, image_blobname: "", alt: "", createdAt: Date(timeIntervalSince1970: 1605186555))])
        ]
        
        var reports:[Timeline] = []
        telemetries.forEach({ telemetry in
            var index = 0
            telemetry.reports.forEach({ report in
                if index < (sequestrations.filter({$0.treeId == Int64(telemetry.treeId)}).first?.sequestration.count)! {
                    
                    reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: "report", reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: sequestrations.filter({$0.treeId == Int64(telemetry.treeId)}).first?.sequestration[index], image_blobname: nil))
                    
                } else {
                    reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: "report", reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: nil, image_blobname: nil))
                }
                
                index += 1
            })
        })
        
        timelineTreeDic.forEach({ tree in
            reports.append(Timeline(treeId: tree.key, type: "tree", reportedOn: tree.value.adoptedDate, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: nil))
        })
        
        
        images.forEach({ image in
            image.images.forEach({ imageDetail in
                reports.append(Timeline(treeId: imageDetail.tree_id, type: "image", reportedOn: imageDetail.createdAt, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image_blobname: imageDetail.image_blobname))
            })
        })
        
        let reportsSorted = reports.sorted(by: {$0.reportedOn > $1.reportedOn})
        self.reports = reportsSorted
        print(self.reports)
    }
    
    func createTimelineTreeObject(trees: [Tree]) {
//        let trees = [
//            Tree(id: 1, forestId: 1, productId: 1, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 1, order_id: 1, created_at: Date(timeIntervalSince1970: 1604236155), expire_date: Date(timeIntervalSince1970: 1112400000), tree_name: "White oak", tree_color: "#9DA536FF"), latitude: "", longitude: ""),
//
//            Tree(id: 2, forestId: 2, productId: 2, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 2, order_id: 2, created_at: Date(timeIntervalSince1970: 1576248170), expire_date: Date(timeIntervalSince1970: 1115424000), tree_name: "Tree", tree_color: "#3655a5"), latitude: "", longitude: "")
//
//        ]
        treeTypeFilter.append(TimelineFilter(treeId: 0, treeName: "All"))
        trees.forEach({ tree in
            if let treeId = tree.assignedTree?.tree_id {
                if let treeName = tree.assignedTree?.tree_name {
                    if let treeColor = tree.assignedTree?.tree_color {
                        if let treeDate = tree.assignedTree?.created_at {
                            
                            timelineTreeDic[treeId] = TimelineTree(treeName: treeName, treeColor: treeColor, adoptedDate: treeDate)
                            treeTypeFilter.append(TimelineFilter(treeId: treeId, treeName: treeName.isEmpty ? "Unnamed Tree" : treeName))
                        }
                    }
                }
            }
        })
    }
    
    func createTimelineDateFilter(trees: [Tree]) {
        
//        let telemetries = [
//            Telemetry(id: "1", treeId: "1", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1606828056), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1605186555), temperature: 23, humidity: 80, treeLength: 20, treeDiameter: 20)]),
//            Telemetry(id: "2", treeId: "2", reports: [Report(reportedOn: Date(timeIntervalSince1970: 1602508155), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20), Report(reportedOn: Date(timeIntervalSince1970: 1607778456), temperature: 21, humidity: 80, treeLength: 20, treeDiameter: 20)])
//        ]
        
//        let trees = [
//            Tree(id: 1, forestId: 1, productId: 1, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 1, order_id: 1, created_at: Date(timeIntervalSince1970: 1604236155), expire_date: Date(timeIntervalSince1970: 1112400000), tree_name: "White oak", tree_color: "#9DA536FF"), latitude: "", longitude: ""),
//
//            Tree(id: 2, forestId: 2, productId: 2, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 2, order_id: 2, created_at: Date(timeIntervalSince1970: 1576248170), expire_date: Date(timeIntervalSince1970: 1115424000), tree_name: "Tree", tree_color: "#3655a5"), latitude: "", longitude: "")
//
//        ]
        datesFilter.append(DateComponents())
        telemetries.forEach({ telemetry in
            telemetry.reports.forEach({ report in
                if !datesFilter.contains(Calendar.current.dateComponents([.year], from: report.reportedOn)) {
                    datesFilter.append(Calendar.current.dateComponents([.year], from: report.reportedOn))
                }
            })
        })
        
        trees.forEach({ tree in
            if let treeDate = tree.assignedTree?.created_at {
                
                if !datesFilter.contains(Calendar.current.dateComponents([.year], from: treeDate)) {
                    datesFilter.append(Calendar.current.dateComponents([.year], from: treeDate))
                }
            }
        })
        
        areFiltersDataReady = true
    }
    
}
