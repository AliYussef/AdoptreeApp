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
    @Published var treeImages: [TreeImage] = []
    @Published var wildlifes: [Wildlife] = []
    @Published var isExpanded: [Bool] = [true]
    private let treeRepository: TreeRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let contentRepository: ContentRepositoryProtocol
    private let forestRepository: ForestRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(treeRepository: TreeRepositoryProtocol, userRepository: UserRepositoryProtocol, contentRepository: ContentRepositoryProtocol, forestRepository: ForestRepositoryProtocol) {
        self.treeRepository = treeRepository
        self.userRepository = userRepository
        self.contentRepository = contentRepository
        self.forestRepository = forestRepository
    }
}

extension TreeViewModel {
    
//    func getTreeData(from forestId: Int64, of userId: Int64 ) {
//        let treesUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .trees(1), using: .get)
//        let imagesUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .treeImages(1), using: .get)
//        let wildlifeUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .wildlifeByForest(forestId), using: .get)
//
//        Publishers.CombineLatest3(userRepository.getAdoptedTrees(using: treesUrlRequest), treeRepository.getTreeImages(using: imagesUrlRequest), forestRepository.getWildlife(using: wildlifeUrlRequest))
//            .sink(receiveCompletion: {result in
//                switch result {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        switch error {
//                            case let urlError as URLError:
//                                print(urlError)
//                            //completion(.failure(.urlError(urlError)))
//                            case let decodingError as DecodingError:
//                                print(decodingError)
//                            //completion(.failure(.decodingError(decodingError)))
//                            default:
//                                print(error)
//                            //completion(.failure(.genericError(error)))
//                        }
//                }
//
//            }, receiveValue: {trees, treeImages, wildlifes in
//                self.trees
//            })
//
//    }
    
}

extension TreeViewModel {
    
    func getAdoptedTrees(of userId:Int64 ,completion: @escaping (Result<[Tree], RequestError>) -> Void) {
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
                self.trees = result
                for _ in self.trees.indices {
                    self.isExpanded.append(false)
                }
            })
            .store(in: &cancellables)
    }
    
}

extension TreeViewModel {
    
    func getTreeImages(for treeId:Int64 ,completion: @escaping (Result<TreeImage, RequestError>) -> Void) {
        
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
