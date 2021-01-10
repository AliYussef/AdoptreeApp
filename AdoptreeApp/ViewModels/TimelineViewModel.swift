//
//  TimelineViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine
import os

class TimelineViewModel: ObservableObject {
    @Published var reports: [Timeline] = []
    @Published var telemetries: [Telemetry] = []
    @Published var sequestrations: [Sequestration] = []
    @Published var timelineTreeDic: [Int64: TimelineTree] = [:]
    @Published var areFiltersDataReady: Bool = false
    @Published var treeTypeFilter: [TimelineFilter] = []
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
        
        Publishers.CombineLatest(telemetryRepository.getTelemetryByTree(using: telemetryUrlRequest), treeRepository.getTreeSequestraion(using: sequestrationUrlRequest))
            .sink(receiveValue: { telemetries, sequestrations in
                switch(telemetries) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                os_log("Decoding error", type: .error, decodingError.localizedDescription)
                            case .urlError(let urlError):
                                os_log("Url error", type: .error, urlError.localizedDescription)
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
                        }
                        
                    case .success(let telemetries):
                        if !self.telemetries.contains(where: {$0.treeId == telemetries.treeId}) {
                            self.telemetries.append(telemetries)
                        }
                }
                
                switch(sequestrations) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                os_log("Decoding error", type: .error, decodingError.localizedDescription)
                            case .urlError(let urlError):
                                os_log("Url error", type: .error, urlError.localizedDescription)
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
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
//        let images = [
//            TreeImage(tree_id: 30, images: [ImageDetail(id: 1, tree_id: 30, image_blobname: "0", alt: "", createdAt: Date(timeIntervalSince1970: 1612444545))]),
//            TreeImage(tree_id: 32, images: [ImageDetail(id: 2, tree_id: 32, image_blobname: "1", alt: "", createdAt: Date(timeIntervalSince1970: 1612530945))])
//        ]
        
        var reports:[Timeline] = []
        telemetries.forEach({ telemetry in
            var index = 0
            telemetry.reports.forEach({ report in
                if index < (sequestrations.filter({$0.treeId == Int64(telemetry.treeId)}).first?.sequestration.count)! {
                    
                    reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: TimelineEntryType.report, reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: sequestrations.filter({$0.treeId == Int64(telemetry.treeId)}).first?.sequestration[index], image: nil))
                    
                } else {
                    reports.append(Timeline(treeId: Int64(telemetry.treeId)!, type: TimelineEntryType.report, reportedOn: report.reportedOn, temperature: report.temperature, humidity: report.humidity, treeLength: report.treeLength, treeDiameter: report.treeDiameter, sequestration: nil, image: nil))
                }
                
                index += 1
            })
        })
        
        timelineTreeDic.forEach({ tree in
            reports.append(Timeline(treeId: tree.key, type: TimelineEntryType.tree, reportedOn: tree.value.adoptedDate, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image: nil))
        })
        
        
        images?.forEach({ image in
            image.images.forEach({ imageDetail in
                reports.append(Timeline(treeId: imageDetail.tree_id, type: TimelineEntryType.image, reportedOn: imageDetail.createdAt, temperature: nil, humidity: nil, treeLength: nil, treeDiameter: nil, sequestration: nil, image: imageDetail.image))
            })
        })
        
        let reportsSorted = reports.sorted(by: {$0.reportedOn > $1.reportedOn})
        self.reports = reportsSorted
    }
    
    func createTimelineTreeObject(trees: [Tree]) {
        
        treeTypeFilter.append(TimelineFilter(treeId: 0, treeName: "All"))
        trees.forEach({ tree in
            if let treeId = tree.assignedTree?.tree_id {
                if let treeName = tree.assignedTree?.tree_name {
                    if let treeColor = tree.assignedTree?.tree_color {
                        if let treeDate = tree.dateSeeded {
                            
                            timelineTreeDic[treeId] = TimelineTree(treeName: treeName, treeColor: treeColor, adoptedDate: treeDate)
                            treeTypeFilter.append(TimelineFilter(treeId: treeId, treeName: treeName.isEmpty ? "Unnamed Tree" : treeName))
                        }
                    }
                }
            }
        })
    }
    
    func createTimelineDateFilter(trees: [Tree]) {
        
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

extension TimelineViewModel {

    func clearDataForLogout() {
        reports.removeAll()
        telemetries.removeAll()
        sequestrations.removeAll()
        timelineTreeDic.removeAll()
        areFiltersDataReady = false
        treeTypeFilter.removeAll()
        datesFilter.removeAll()
    }
}
