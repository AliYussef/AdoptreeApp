//
//  OrderViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class OrderViewModel: ObservableObject {
    @Published var products: [OrderProduct] = []
    @Published var availableProducts: [Product] = []
    @Published var treeSign: Product?
    @Published var categories: [Category] = []
    @Published var categoriesDic: [Int8: String] = [:]
    @Published var totalPrice: Double = 0.0
    @Published var order: OrderResponse?
    private var cancellables = Set<AnyCancellable>()
    private let orderRepository: OrderRepositoryProtocol
    private let productRepository: ProductRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol
    
    init(orderRepository: OrderRepositoryProtocol, productRepository: ProductRepositoryProtocol, categoryRepository: CategoryRepositoryProtocol) {
        self.orderRepository = orderRepository
        self.productRepository = productRepository
        self.categoryRepository = categoryRepository
//        self.availableProducts = [
//            Product(id: 1, categoryId: 1, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200)),
//           Product(id: 2, categoryId: 2, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200)),
//           Product(id: 3, categoryId: 2, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200)),
//            Product(id: 4, categoryId: 1, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200))
//
//        ]
        
//        self.products = [
//            OrderProduct(product: Product(id: 1, categoryId: 1, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200))),
//            OrderProduct(product: Product(id: 1, categoryId: 2, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200))),
//            OrderProduct(product: Product(id: 1, categoryId: 2, name: "White oak", description: "A", price: 35, vatRateId: 1, isUpForAdoption: true, stock: 100, createdAt: Date(timeIntervalSince1970: 1111795200)))
//
//        ]
        
//        self.categories = [
//            Category(id: 1, name: "Sapling", description: "A young tree"),
//            Category(id: 2, name: "Tree", description: "A non-young tree"),
//            Category(id: 3, name: "Tree Sign", description: "A personal sign placed next to your tree")
//        ]
        
        self.getEc(){_ in}
      
        
  
    }
}

extension OrderViewModel {
    
    func getEc(completion: @escaping (Result<OrderResponse, RequestError>) -> Void) {
        print("Started")
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .product, using: .get)
        let urlRequest1 = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .category, using: .get)
        
        Publishers.CombineLatest(productRepository.getProducts(using: urlRequest), categoryRepository.getCategories(using: urlRequest1))
            .sink(receiveCompletion: {result in
                print(result)
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
                
            }, receiveValue: {products, categories in
                self.availableProducts = products
                self.categories = categories
                self.createCategoriesDictionary()
                self.getTreeSignProduct()
            })
            .store(in: &cancellables)
    }
    
    func createOrder(order: Order, completion: @escaping (Result<OrderResponse, RequestError>) -> Void) {
        
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .order, using: .post, withParams: order)
            
            orderRepository.createOrder(using: urlRequest)
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
                    self.order = result
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
}

extension OrderViewModel {
    
    func getProducts(completion: @escaping (Result<[Product], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .product, using: .get)
        
        productRepository.getProducts(using: urlRequest)
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
                self.availableProducts = result
            })
            .store(in: &cancellables)
    }
    
    func add(product: Product) {
        if let index = products.firstIndex(where: {$0.product.id == product.id}) {
            products[index].quantity += 1
        }
        else{
            products.append(OrderProduct(product: product))
        }
    }
    
    func remove(product: Product) {
        if let index = products.firstIndex(where: {$0.product.id == product.id}) {
            products.remove(at: index)
        }
    }
    
    func increaseQuantity(of product: Product) {
        if let index = products.firstIndex(where: {$0.product.id == product.id}) {
            products[index].quantity += 1
        }
    }
    
    func decreaseQuantity(of product: Product) {
        if let index = products.firstIndex(where: {$0.product.id == product.id}) {
            products[index].quantity -= 1
        }
    }
    
    func activateTreeSign(is isActivated: Bool ,for product: Product) {
        if let index = products.firstIndex(where: {$0.product.id == product.id}) {
            products[index].isSignActivated = isActivated
        }
    }
    
    func calculateTotal() {
        var total: Double = 0.0
        
        products.forEach({ product in
            total += product.product.price * Double(product.quantity)
            if product.isSignActivated {
                total += treeSign?.price ?? 5.0
            }
        })
        //print(products)
        self.totalPrice = total
    }
}

extension OrderViewModel {
    
    func getCategories(completion: @escaping (Result<[Category], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .category, using: .get)
        
        categoryRepository.getCategories(using: urlRequest)
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
                self.categories = result
            })
            .store(in: &cancellables)
    }
    
    func createCategoriesDictionary() {
        categories.forEach({ cat in
            categoriesDic[cat.id] = cat.name
        })
    }
}

extension OrderViewModel {
    
    func getTreeSignProduct() {
        availableProducts.forEach({ product in
            if categoriesDic[product.categoryId] == "Tree Sign" {
                treeSign = product
            }
        })
    }
}
