//
//  NotificationDevice.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct NotificationDevice: Codable {
    let id: Int64
    let userId: Int64 //required
    let deviceToken: String //required
    let createdAt: String
    let deletedAt: String
}
