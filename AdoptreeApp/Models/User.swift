//
//  User.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct User: Codable {
    let id: Int64?
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let password: String
    let salt: String?
    let forgetToken: String?
    let role: String?
    let createdAt: Date?
    
}

struct ForgetPasswordBody: Codable {
    let username: String
    let email: String
}

struct ResetPasswordBody: Codable {
    let user_id: Int64?
    let token: String
    let created_at: Date?
    let valid_until: Date?
    let password: String
    let validate_password: String
}

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "Access key"
        case refreshToken = "Refresh token"
        case userId = "UserId"
    }
}

struct RefreshTokenResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
}

struct UserShared: Codable {
    let id: Int64?
    let firstname: String?
    let lastname: String?
    let username: String?
    let email: String?
}
