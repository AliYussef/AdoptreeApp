//
//  Content.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Content: Codable, Identifiable{
    let id: Int64
    let contentId: Int64
    let createdOn: String
    let contentType: Int8
    let title: String
    let text: String
}
