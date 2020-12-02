//
//  TreeSign.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct TreeSign: Codable {
    let id: Int64
    let tree_id: Int64
    let order_id: Int64
    let product_id: Int64
    let sign_text: String
    let createdAt: String
    let deletedAt: String
}
