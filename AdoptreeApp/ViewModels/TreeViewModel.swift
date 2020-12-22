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
    @Published var countries: [Country] = []
    @Published var forests: [Forest] = []
    @Published var isExpanded: [Bool] = [true]
    @Published var treeLocationDic: [Int64: TreeLocation] = [:]
    private let treeRepository: TreeRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let countryRepository: CountryRepositoryProtocol
    private let forestRepository: ForestRepositoryProtocol
    private let treeSignRepository: TreeSignRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(treeRepository: TreeRepositoryProtocol, userRepository: UserRepositoryProtocol, countryRepository: CountryRepositoryProtocol, forestRepository: ForestRepositoryProtocol, treeSignRepository: TreeSignRepositoryProtocol) {
        self.treeRepository = treeRepository
        self.userRepository = userRepository
        self.countryRepository = countryRepository
        self.forestRepository = forestRepository
        self.treeSignRepository = treeSignRepository
        //getAdoptedTrees(of: 1) {_ in}
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
                
                // to be called later
                //                self.trees.forEach({ tree in
                //                    if let treeId = tree.assignedTree?.tree_id {
                //                        self.getTreeImagesAndWildlife(from: tree.forestId, of: treeId)
                //                    }
                //                })
                completion(.success(result))
                //below is already called in content view
                //                self.trees = result
                //                for _ in self.trees.indices {
                //                    self.isExpanded.append(false)
                //                }
            })
            .store(in: &cancellables)
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
    }
    
}

extension TreeViewModel {
    
    func personalizeTree(tree: AssignedTree, completion: @escaping (Result<AssignedTree, RequestError>) -> Void) {
        
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
            
        } catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        } catch let error{
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

extension TreeViewModel {
    
    func getForestsAndCountries() {
        let countryUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .country, using: .get)
        let forestUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .forest, using: .get)
        
        Publishers.CombineLatest(countryRepository.getCountries(using: countryUrlRequest), forestRepository.getForests(using: forestUrlRequest))
            .sink(receiveValue: { countries, forests in
                
                switch(countries) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let results):
                        self.countries = results
                }
                
                switch(forests) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let results):
                        self.forests = results
                        self.createTreeLocationDic()
                }
            })
            .store(in: &cancellables)
    }
    
    func createTreeLocationDic() {
        var forestDic: [Int64 : Int64] = [:]
        
        forests.forEach({ forest in
            forestDic[forest.id] = forest.countryId
        })
        print(forestDic)
        trees.forEach({ tree in
            if let treeId = tree.assignedTree?.tree_id {
                
                treeLocationDic[treeId] = TreeLocation(country: countries.first(where: {$0.id == forestDic[tree.forestId]})?.name ?? "Unknown", forest: forests.first(where: {$0.id == tree.forestId})?.name ?? "Unknown")
            }
        })
        print(treeLocationDic)
    }
    
}

extension TreeViewModel {
    
    func renewTreeContract(for tree: AssignedTree, completion: @escaping (Result<AssignedTree, RequestError>) -> Void) {
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .renewTree, using: .put, withParams: tree)
            
            treeRepository.renewTreeContract(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                    
                }, receiveValue: {result in
                    completion(.success(result))
                    self.updateAssignedTree(assignedTree: result)
                })
                .store(in: &cancellables)
            
        } catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        } catch let error{
            completion(.failure(.genericError(error)))
        }
    }
}
