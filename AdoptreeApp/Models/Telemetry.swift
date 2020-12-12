//
//  Telemetry.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Telemetry: Codable, Identifiable {
    let id: Int64
    let treeId: Int64
    let reports: [Report]
}

struct Report: Codable {
    let reportedOn: Date
    let temperature: Int8
    let humidity: Int8
    let treeLength: Int8
    let treeDiameter: Int8
}


struct Sequestration: Codable {
    let treeId: Int64
    let sequestration: [Double]
}

