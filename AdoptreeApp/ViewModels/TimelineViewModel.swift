//
//  TimelineViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class TimelineViewModel: ObservableObject {
    @Published var telemetries: [Telemetry] = []
    @Published var sequestrations: [Sequestration] = []
    @Published var timelineTreeDic: [Int64: TimelineTree] = [:]
//    var timelineTreeDicShown: [Int64: Bool] = [:]
    private let telemetryRepository: TelemetryRepositoryProtocol
    private let treeRepository: TreeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(telemetryRepository: TelemetryRepositoryProtocol, treeRepository: TreeRepositoryProtocol) {
        self.telemetryRepository = telemetryRepository
        self.treeRepository = treeRepository
        
        createTimelineTreeObject()
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
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let telemetries):
                        //since the response is array but there is always one element only
                        if let telemetry = telemetries.first {
                            self.telemetries.append(telemetry)
                        }
                }
                
                switch(sequestrations) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let sequestrations):
                        self.sequestrations.append(Sequestration(treeId: treeId, sequestration: sequestrations))
                }
            })
            .store(in: &cancellables)
    }
}

extension TimelineViewModel {
  
    func createTimelineTreeObject() {
        let trees = [
            Tree(id: 1, forestId: 1, productId: 1, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 1, order_id: 1, created_at: Date(timeIntervalSince1970: 1604236155), expire_date: Date(timeIntervalSince1970: 1112400000), tree_name: "White oak", tree_color: "#9DA536FF"), latitude: "", longitude: ""),
            
            Tree(id: 2, forestId: 2, productId: 2, health: 13, dateSeeded: nil, assignedTree: AssignedTree(user_id: 1, tree_id: 2, order_id: 2, created_at: Date(timeIntervalSince1970: 1601557755), expire_date: Date(timeIntervalSince1970: 1115424000), tree_name: "Tree", tree_color: "#3655a5"), latitude: "", longitude: "")
            
        ]
        
        trees.forEach({ tree in
            if let treeId = tree.assignedTree?.tree_id {
                if let treeName = tree.assignedTree?.tree_name {
                    if let treeColor = tree.assignedTree?.tree_color {
                        if let treeDate = tree.assignedTree?.created_at {
                            
                            timelineTreeDic[treeId] = TimelineTree(treeName: treeName, treeColor: treeColor, adoptedDate: treeDate)
//                            timelineTreeDicShown[treeId] = false
                        }
                    }
                }
            }
        })
    }
    
//    func showDateTree(treeId: Int64) -> Bool {
//
//        if let treeshown = timelineTreeDicShown[treeId] {
//            if treeshown {
//                return false
//            }
//        }
//
//        timelineTreeDicShown[treeId] = true
//        return true
//    }
    
}
