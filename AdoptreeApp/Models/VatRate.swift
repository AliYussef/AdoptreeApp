//
//  VatRate.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct VatRate: Codable {
    let id: Int64
    let type: String
    let rate: Float16
    let countryId: Int64
}
