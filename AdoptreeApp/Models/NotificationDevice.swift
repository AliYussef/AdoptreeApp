//
//  NotificationDevice.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct NotificationDevice: Codable {
    let id: Int64?
    let userId: Int64
    let deviceToken: String
    let createdAt: Date?
    let deletedAt: Date?
}
