//
//  TreeViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class TreeViewModel: ObservableObject {
    @Published var trees:[Tree] = []
    @Published var isExpanded: [Bool] = [true]
    @Published var treeImages: [TreeImage] = []
    private let treeRepository: TreeRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let contentRepository: ContentRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(treeRepository: TreeRepositoryProtocol, userRepository: UserRepositoryProtocol, contentRepository: ContentRepositoryProtocol) {
        self.treeRepository = treeRepository
        self.userRepository = userRepository
        self.contentRepository = contentRepository
    }
}

extension TreeViewModel {
    
    func getAllTrees(completion: @escaping (Result<[Tree], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .tree, using: .get)
        
        treeRepository.getAllTrees(using: urlRequest)
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
                self.trees = result
            })
            .store(in: &cancellables)
    }
    
}

extension TreeViewModel {
    
    func getAdoptedTrees(completion: @escaping (Result<[Tree], RequestError>) -> Void) {
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .trees(1), using: .get)
        
        userRepository.getAdoptedTrees(using: urlRequest)
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
                print(result)
                self.trees = result
                for _ in self.trees.indices {
                    self.isExpanded.append(false)
                }
            })
            .store(in: &cancellables)
    }
    
}

extension TreeViewModel {
    
    func getTreeImages(completion: @escaping (Result<TreeImage, RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .treeImages(1), using: .get)
        
        treeRepository.getTreeImages(using: urlRequest)
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
                self.treeImages.append(result)
            })
            .store(in: &cancellables)
    }
    
}

extension TreeViewModel {
    
    func getContents(completion: @escaping (Result<[Content], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .content, using: .get)
        
        contentRepository.getContents(using: urlRequest)
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
               // self.treeImages.append(result)
            })
            .store(in: &cancellables)
    }
    
}

