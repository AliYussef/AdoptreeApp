//
//  Order.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Order: Codable, Identifiable {
    let id: Int64?
    let paymentRedirectLink: String?
    let paymentStatus: String?
    let orderStatus: String?
    let userId: Int64
    let createdAt: Date?
    let orderLines: [OrderLine]
}

struct OrderLine: Codable, Identifiable{
    let id: Int64?
    let orderId: Int64?
    let productId: Int64
    let price: Float16?
    let vat: Float16?
    let quantity: Int
}

struct OrderResponse: Decodable {
    let id: Int64
    let paymentLink: String
}

enum PaymentStatus: String {
    case paid, refund, open, expired, canceled, failed, payout, chargeback
}
