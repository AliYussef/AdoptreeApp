//
//  ViewModelHelper.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

struct ViewModelHelper {
    
    static func buildUrlRequestWithParam<Params: Encodable>(withEndpoint endpoint: ApiEndPoint,using method: RequestMethod,withParams params: Params?) throws -> URLRequest {
        
        let fullUrl = BaseURL.url + endpoint.description
        let url = URL(string: fullUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
        
        let fullUrl = BaseURL.url + endpoint.description
        let url = URL(string: fullUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
}
