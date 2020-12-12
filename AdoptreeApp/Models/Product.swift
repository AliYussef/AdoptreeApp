//
//  Product.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int64
    let categoryId: Int8
    let name: String
    let description: String
    let price: Double
    let vatRateId: Int8
    let isUpForAdoption: Bool
    let stock: Int64
    let createdAt: Date
}

struct OrderProduct: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int = 1
    var isSignActivated: Bool = false
}
