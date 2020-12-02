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
    let dateTime: String
    let forestId: Int64
    let slots: Int8
    let language: String
    let guideName: String
    let guideSpecialty: String
}

struct BookedTour: Codable, Identifiable {
    let id: Int64
    let tourId: Int64 //required
    let userId: Int64 //required
    let userName: String //required
    let userEmail: String //required
    let bookedDateTime: String
}
