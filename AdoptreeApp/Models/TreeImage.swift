//
//  TreeImage.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct TreeImage: Codable {
    let tree_id: Int64
    let images: [ImageDetail]
}

struct ImageDetail: Codable, Identifiable {
    let id: Int64
    let tree_id: Int64
    let image_blobname: String
    let alt: String
    let createdAt: Date
}
