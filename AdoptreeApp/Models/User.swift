//
//  User.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct User: Codable {
    let id: Int64
    let firstname: String //required
    let lastname: String //required
    let username: String //required
    let email: String //required
    let password: String //required
    let forgetToken: String
    
    //    enum CodingKeys: String, CodingKey {
    //        case username = "username"
    //    }
}

struct LoginResponse: Decodable {
    let authtoken: String
    
    enum CodingKeys: String, CodingKey {
        case authtoken = "authtoken"
    }
}
