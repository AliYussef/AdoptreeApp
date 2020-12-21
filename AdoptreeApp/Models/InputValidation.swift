//
//  InputValidation.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 20/12/2020.
//

import Foundation

enum InputValidation {
    case success
    case failure(message: String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
