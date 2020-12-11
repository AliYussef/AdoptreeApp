//
//  Wildlife.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct WildlifeOutput: Codable {
    let forestId: Int64
    let wildlife: [Wildlife]
}

struct Wildlife: Codable, Identifiable {
    let id: Int64
    let name: String
    let description: String
}
