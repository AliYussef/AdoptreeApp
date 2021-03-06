//
//  Content.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Content: Codable, Identifiable{
    let id: String
    let contentId: String
    let createdOn: Date
    let contentType: String
    let title: String
    let text: String
}

enum ContentType: String {
    case about, announcement, event, informative
}
