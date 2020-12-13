//
//  Tour.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct Tour: Codable, Identifiable {
    let id: Int64
    let description: String
    var dateTime: Date
    let forestId: Int64
    let slots: Int8
    let language: String
    let guideName: String
    let guideSpecialty: String
}

struct BookedTour: Codable, Identifiable {
    let id: Int64?
    let tourId: Int64
    let userId: Int64
    let userName: String
    let userEmail: String
    let bookedDateTime: Date?
}
