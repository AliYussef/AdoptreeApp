//
//  Tree.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import SwiftUI
import MapKit

struct Tree: Codable, Identifiable {
    let id: Int64
    let forestId: Int64
    let productId: Int64
    let health: Int8
    let dateSeeded: Date?
    var assignedTree: AssignedTree?
    let latitude: String
    let longitude: String
}

extension Tree {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
    }
}

struct AssignedTree: Codable {
    let user_id: Int64
    let tree_id: Int64
    let order_id: Int64
    let created_at: Date
    let expire_date: Date
    var tree_name: String?
    var tree_color: String?
}

struct TreeLocation {
    let country: String
    let forest: String
}

enum TreeType: String {
    case tree, sapling
}
