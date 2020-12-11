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
    @Published var wildlifes: [WildlifeOutput] = []
    @Published var treeSign: TreeSign?
    @Published var isExpanded: [Bool] = [true]
    private let treeRepository: TreeRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let contentRepository: ContentRepositoryProtocol
    private let forestRepository: ForestRepositoryProtocol
    private let treeSignRepository: TreeSignRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(treeRepository: TreeRepositoryProtocol, userRepository: UserRepositoryProtocol, contentRepository: ContentRepositoryProtocol, forestRepository: ForestRepositoryProtocol, treeSignRepository: TreeSignRepositoryProtocol) {
        self.treeRepository = treeRepository
        self.userRepository = userRepository
        self.contentRepository = contentRepository
        self.forestRepository = forestRepository
        self.treeSignRepository = treeSignRepository
        getAdoptedTrees(of: 1) {_ in}
    }
}

extension TreeViewModel {
    
    func getTreeImagesAndWildlife(from forestId: Int64, of treeId: Int64 ) {
        let imagesUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .treeImages(treeId), using: .get)
        let wildlifeUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .wildlifeByForest(forestId), using: .get)
        
        Publishers.CombineLatest(treeRepository.getTreeImages(using: imagesUrlRequest), forestRepository.getWildlife(using: wildlifeUrlRequest))
            .sink(receiveValue: { images, wildlife in
                switch(images) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let images):
                        self.treeImages.append(images)
                }
                
                switch(wildlife) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let wildlife):
                        self.wildlifes.append(WildlifeOutput(forestId: forestId, wildlife: wildlife))
                }
            })
            .store(in: &cancellables)
        //            .sink(receiveCompletion: {result in
        //                switch result {
        //                    case .finished:
        //                        break
        //                    case .failure(let error):
        //                        switch error {
        //                            case let urlError as URLError:
        //                                print(urlError)
        //                            case let decodingError as DecodingError:
        //                                print(decodingError)
        //                            default:
        //                                print(error)
        //                        }
        //                }
        //
        //            }, receiveValue: { treeImages, wildlifes in
        //                self.treeImages.append(treeImages)
        //                self.wildlifes.append(WildlifeOutput(forestId: forestId, wildlife: wildlifes))
        //            })
        //            .store(in: &cancellables)
        
    }
    
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
                self.trees = result
                for _ in self.trees.indices {
                    self.isExpanded.append(false)
                }
                
                self.trees.forEach({ tree in
                    if let treeId = tree.assignedTree?.tree_id {
                        self.getTreeImagesAndWildlife(from: tree.forestId, of: treeId)
                    }
                })
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
    
}

extension TreeViewModel {
    
    //    func getTreeImages(for treeId:Int64 ,completion: @escaping (Result<TreeImage, RequestError>) -> Void) {
    //
    //        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .treeImages(1), using: .get)
    //
    //        treeRepository.getTreeImages(using: urlRequest)
    //            .sink(receiveCompletion: {result in
    //                switch result {
    //                    case .finished:
    //                        break
    //                    case .failure(let error):
    //                        switch error {
    //                            case let urlError as URLError:
    //                                print(urlError)
    //                                completion(.failure(.urlError(urlError)))
    //                            case let decodingError as DecodingError:
    //                                print(decodingError)
    //                                completion(.failure(.decodingError(decodingError)))
    //                            default:
    //                                print(error)
    //                                completion(.failure(.genericError(error)))
    //                        }
    //                }
    //
    //            }, receiveValue: {result in
    //                completion(.success(result))
    //                self.treeImages.append(result)
    //            })
    //            .store(in: &cancellables)
    //    }
    
}

extension TreeViewModel {
    
    //    func getWildlife(from forestId: Int64, completion: @escaping(Result<[Wildlife], RequestError>) -> Void) {
    //
    //        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .wildlifeByForest(forestId), using: .get)
    //
    //        forestRepository.getWildlife(using: urlRequest)
    //            .sink(receiveCompletion: {result in
    //                switch result {
    //                    case .finished:
    //                        break
    //                    case .failure(let error):
    //                        switch error {
    //                            case let urlError as URLError:
    //                                print(urlError)
    //                                completion(.failure(.urlError(urlError)))
    //                            case let decodingError as DecodingError:
    //                                print(decodingError)
    //                                completion(.failure(.decodingError(decodingError)))
    //                            default:
    //                                print(error)
    //                                completion(.failure(.genericError(error)))
    //                        }
    //                }
    //
    //            }, receiveValue: {result in
    //                self.wildlifes.append(WildlifeOutput(forestId: forestId, wildlife: result))
    //                completion(.success(result))
    //            })
    //            .store(in: &cancellables)
    //    }
}

extension TreeViewModel {
    
    
    func personalizeTree(tree: AssignedTree, completion: @escaping (Result<AssignedTree, RequestError>) -> Void) {
        //AssignedTree2(user_id: tree.user_id, tree_id: tree.tree_id, order_id: tree.order_id, tree_name: tree.tree_name, tree_color: tree.tree_color)
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .personalize, using: .put, withParams: tree)
            
            treeRepository.personalizeTree(using: urlRequest)
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
                    self.updateAssignedTree(assignedTree: result)
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    func updateAssignedTree(assignedTree: AssignedTree) {
        if let index = self.trees.firstIndex(where: {$0.assignedTree?.tree_id == assignedTree.tree_id}) {
            self.trees[index].assignedTree = assignedTree
        }
    }
}

extension TreeViewModel {
    
    func createTreeSign(treeSign: TreeSign, completion: @escaping (Result<TreeSign, RequestError>) -> Void) {
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .treesign, using: .post, withParams: treeSign)
            
            treeSignRepository.createTreeSign(using: urlRequest)
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
                    self.treeSign = result
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    func getTreeSignByTree(for treeId: Int64, completion: @escaping (Result<TreeSign, RequestError>) -> Void) {
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .treesignByTree(treeId), using: .get)
        
        treeSignRepository.createTreeSign(using: urlRequest)
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
                self.treeSign = result
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
    
    func createTreeSignObject(tree: Tree, treeSignProduct: Product, signText: String, orderId: Int64) -> TreeSign? {
        var treeSign: TreeSign?
        if let treeId = tree.assignedTree?.tree_id {
            //if let productId = treeSign?.id {
            treeSign = TreeSign(id: nil, tree_id: treeId, product_id: treeSignProduct.id, sign_text: signText, order_id: orderId, createdAt: nil, deletedAt: nil)
            //}
        }
        return treeSign
    }
    
}
