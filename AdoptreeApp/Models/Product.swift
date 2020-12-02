//
//  Product.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Product: Codable {
    let id: Int64
    let categoryId: Int64 //required
    let name: String //required
    let description: String
    let price: Float16
    let vatRateId: Float16
    let isUpForAdoption: Bool
    let stock: Int64
    let createdAt: String
}
