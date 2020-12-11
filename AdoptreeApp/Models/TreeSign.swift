//
//  TreeSign.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct TreeSign: Codable {
    let id: Int64?
    let tree_id: Int64
    let product_id: Int64
    let sign_text: String
    let order_id: Int64?
    let createdAt: Date?
    let deletedAt: Date?
}
