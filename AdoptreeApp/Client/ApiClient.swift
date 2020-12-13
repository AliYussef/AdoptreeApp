//
//  ApiClient.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

final class ApiClient {
    static let sharedApiClient = ApiClient()
    var number = 0
    
    lazy var decoder: JSONDecoder = {
        let dateNoTimeFormatter = DateFormatter()
        dateNoTimeFormatter.dateFormat = "yyyy-MM-dd"
        
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let serverFullDateFormatter = DateFormatter()
        serverFullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let len = dateStr.count
            var date: Date? = nil
            if dateNoTimeFormatter.date(from: dateStr) != nil {
                date = dateNoTimeFormatter.date(from: dateStr)
            } else if isoDateFormatter.date(from: dateStr) != nil {
                date = isoDateFormatter.date(from: dateStr)
            } else {
                date = serverFullDateFormatter.date(from: dateStr)
            }
            guard let date_ = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return date_
        })
        return decoder
    }()
    
    private init() {}
}

extension ApiClient {
    
    func executeRequestWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<ResponseType, Error> {

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                //~= pattern match operator
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: ResponseType.self, decoder: self.decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
   
    func executeRequestsWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<Result<ResponseType, RequestError>, Never> {

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: ResponseType.self, decoder: self.decoder)
            .map {
                .success($0)
            }
            .catch { error -> Just<Result<ResponseType, RequestError>> in
                if let urlError = error as? URLError {
                    return Just(.failure(RequestError.urlError(urlError)))
                } else if let decodingError = error as? DecodingError {
                    return Just(.failure(RequestError.decodingError(decodingError)))
                } else {
                    return Just(.failure(RequestError.genericError(error)))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func executeRequestWithoutResponseBody(using request: URLRequest) -> AnyPublisher<HTTPURLResponse, URLError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .compactMap { $0.response as? HTTPURLResponse }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct BaseURL {
    static let url = "https://tree-adoption.azurewebsites.net/api/v1/"
    
    // another solution
    //    static let base = URL(string: "https://api.github.com")!
    //    let request = URLRequest(url: base.appendingPathComponent("users/\(username)/repos"))
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestError: Error, CustomStringConvertible {
    case noInternetConnection
    case urlError(URLError)
    case decodingError(DecodingError)
    case encodingError(EncodingError)
    case genericError(Error)
    
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
        }
    }
}
