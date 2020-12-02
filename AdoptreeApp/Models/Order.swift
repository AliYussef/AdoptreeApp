//
//  Order.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Order: Codable {
    let id: Int64
    let paymentStatus: Int8
    let orderStatus: Int8
    let userId: Int64 //required
    let createdAt: String
    let orderLines: [OrderLine] //required
}

struct OrderLine: Codable{
    let id: Int64
    let orderId: Int64
    let productId: Int64 //required
    let price: Float16
    let vat: Float16
    let quantity: Int64 //required
}

struct OrderResponse: Decodable {
    let id: Int64
    let paymentLink: String
}
