//
//  Timeline.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 12/12/2020.
//

import Foundation

struct Timeline: Codable, Identifiable {
    var id = UUID()
    let treeId: Int64
    let type: TimelineEntryType
    let reportedOn: Date
    let temperature: Int8?
    let humidity: Int8?
    let treeLength: Int8?
    let treeDiameter: Int8?
    let sequestration: Double?
    let image_blobname: String?
}

struct TimelineTree {
    var treeName: String
    var treeColor: String
    let adoptedDate: Date
}

struct TimelineFilter {
    let treeId: Int64
    var treeName: String
}

enum TimelineEntryType: String, Codable {
    case report, tree, image
}
