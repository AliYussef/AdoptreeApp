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
    //let decoder = JSONDecoder()
    // private var cancellables = Set<AnyCancellable>()
    private init() {}
}

extension ApiClient {
    
    // decoder.dateDecodingStrategy = .formatted(DateFormatter())
    
    func executeRequestWithResponseBody<ResponseType: Decodable>(using request: URLRequest) -> AnyPublisher<ResponseType, Error> {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: ResponseType.self, decoder: decoder)
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
