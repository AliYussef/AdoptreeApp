//
//  RequestError.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/01/2021.
//

import Foundation

enum RequestError: Error, CustomStringConvertible {
    case noInternetConnection
    case urlError(URLError)
    case decodingError(DecodingError)
    case encodingError(EncodingError)
    case genericError(Error)
    case invalidToken
    
    var description: String {
        switch self {
            case .noInternetConnection:
                return "No internet connection"
            case .urlError(let urlError):
                return "\(urlError)"
            case .decodingError(let decodingError):
                return "\(decodingError)"
            case .encodingError(let encodingError):
                return "\(encodingError)"
            case .genericError(let error):
                return "\(error)"
            case .invalidToken:
                return "Invalid token"
        }
    }
}

enum AuthenticationError: Error {
    case loginRequired
}
