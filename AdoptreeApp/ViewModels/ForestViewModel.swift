//
//  ForestViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class ForestViewModel: ObservableObject {
    @Published var wildlifes: [Wildlife] = []
    private let forestRepository: ForestRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(forestRepository: ForestRepositoryProtocol) {
        self.forestRepository = forestRepository
    }
}

extension ForestViewModel {
    
    func getWildlife(from forestId: Int64, completion: @escaping(Result<[Wildlife], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .wildlifeByForest(forestId), using: .get)
        
        forestRepository.getWildlife(using: urlRequest)
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                print(urlError)
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                print(decodingError)
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                print(error)
                                completion(.failure(.genericError(error)))
                        }
                }
                
            }, receiveValue: {result in
                completion(.success(result))
                self.wildlifes = result
            })
            .store(in: &cancellables)
    }
}
