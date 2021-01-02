//
//  ViewModelHelper.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct ViewModelHelper {
    
    static func buildUrlRequestWithParam<Params: Encodable>(withEndpoint endpoint: ApiEndPoint,using method: RequestMethod,withParams params: Params?) throws -> URLRequest {
//
//        if UserViewModel.shared.isAuthenticated {
//            if checkTokenValidity() {
//                UserViewModel.shared.refreshToken {_ in}
//            }
//        }
        
        let fullUrl = BaseURL.url + endpoint.description
        let url = URL(string: fullUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let accessToken = UserViewModel.shared.accessToken {
//            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        urlRequest.httpMethod = method.rawValue
        
        
        if params != nil {
            do {
                let encoder = JSONEncoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                encoder.dateEncodingStrategy = .formatted(formatter)
                
                let body = try encoder.encode(params)
                urlRequest.httpBody = body
                
            } catch let error {
                if let encodingError = error as? EncodingError {
                    throw encodingError
                }
            }
        }
        
        return urlRequest
    }
    
    static func buildUrlRequestWithoutParam(withEndpoint endpoint: ApiEndPoint,using method: RequestMethod) -> URLRequest {
        
//        if UserViewModel.shared.isAuthenticated {
//            if checkTokenValidity() {
//                UserViewModel.shared.refreshToken {_ in}
//            }
//        }
        
        let fullUrl = BaseURL.url + endpoint.description
        let url = URL(string: fullUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let accessToken = UserViewModel.shared.accessToken {
//            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    private static func checkTokenValidity() -> Bool {
        var dateDiff = DateComponents()
        
        if let authenticationTimeString = UserViewModel.shared.authenDate {
            if let authenticationTime = Double(authenticationTimeString) {
                dateDiff = Calendar.current.dateComponents([.minute], from: Date(timeIntervalSince1970: authenticationTime), to: Date())
            }
        }
        
        guard dateDiff.minute != nil else {
            return false
        }
        
        return dateDiff.minute! >= 9
    }
    
}
