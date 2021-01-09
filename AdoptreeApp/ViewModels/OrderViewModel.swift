//
//  OrderViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine
import os

class OrderViewModel: ObservableObject {
    @Published var products: [OrderProduct] = []
    @Published var availableProducts: [Product] = []
    @Published var treeSign: Product?
    @Published var categories: [Category] = []
    @Published var categoriesDic: [Int8: String] = [:]
    @Published var totalPrice: Double = 0.0
    @Published var orderResponse: OrderResponse?
    @Published var order: Order?
    @Published var treeSpeciesFilter: [String] = []
    @Published var treeConditionFilter: [String] = []
    private let initialTreeSignPrice = 5.0
    private let orderRepository: OrderRepositoryProtocol
    private let productRepository: ProductRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(orderRepository: OrderRepositoryProtocol, productRepository: ProductRepositoryProtocol, categoryRepository: CategoryRepositoryProtocol) {
        self.orderRepository = orderRepository
        self.productRepository = productRepository
        self.categoryRepository = categoryRepository
    }
}

extension OrderViewModel {
    
    func getProductsAndCategories() {
        let productUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .product, using: .get)
        let categoryUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .category, using: .get)
        
        Publishers.Zip(productRepository.getProducts(using: productUrlRequest), categoryRepository.getCategories(using: categoryUrlRequest))
            .sink(receiveValue: { products, categories in
                switch(products) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                os_log("Decoding error", type: .error, decodingError.localizedDescription)
                            case .urlError(let urlError):
                                os_log("Url error", type: .error, urlError.localizedDescription)
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
                        }
                        
                    case .success(let products):
                        self.availableProducts = products
                        self.createTreeSpeciesFilter()
                }
                
                switch(categories) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                os_log("Decoding error", type: .error, decodingError.localizedDescription)
                            case .urlError(let urlError):
                                os_log("Url error", type: .error, urlError.localizedDescription)
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
                        }
                        
                    case .success(let categories):
                        self.categories = categories
                        self.createCategoriesDictionary()
                }
            })
            .store(in: &cancellables)
    }
}

extension OrderViewModel {
    
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
                                    os_log("Url error", type: .error, urlError.localizedDescription)
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    os_log("Error", type: .error, error.localizedDescription)
                                    completion(.failure(.genericError(error)))
                            }
                    }
                    
                }, receiveValue: {result in
                    self.orderResponse = result
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            os_log("Encoding error", type: .error, encodingError.localizedDescription)
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            os_log("Error", type: .error, error.localizedDescription)
            completion(.failure(.genericError(error)))
        }
    }
    
    func getOrderById(using orderId: Int64, completion: @escaping (Result<Order, RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .orderById(orderId), using: .get)
        
        orderRepository.getOrderById(using: urlRequest)
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                os_log("Url error", type: .error, urlError.localizedDescription)
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
                                completion(.failure(.genericError(error)))
                        }
                }
                
            }, receiveValue: {result in
                self.order = result
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
}

extension OrderViewModel {
    
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
    
    func createOrderObject(for userID: Int64) -> Order {
        var orderLines: [OrderLine] = []
        products.forEach({ orderProduct in
            if orderProduct.isSignActivated {
                if let treeSign = treeSign {
                    orderLines.append(OrderLine(id: nil, orderId: nil, productId: treeSign.id, price: nil, vat: nil, quantity: 1))
                }
            }
            orderLines.append(OrderLine(id: nil, orderId: nil, productId: orderProduct.product.id, price: nil, vat: nil, quantity: orderProduct.quantity))
        })
        
        return Order(id: nil, paymentRedirectLink: PaymentURL.url, paymentStatus: nil, orderStatus: nil, userId: userID, createdAt: nil, orderLines: orderLines)
    }
    
    func calculateTotal() {
        var total: Double = 0.0
        
        products.forEach({ product in
            total += product.product.price * Double(product.quantity)
            if product.isSignActivated {
                total += treeSign?.price ?? initialTreeSignPrice
            }
        })
        
        self.totalPrice = total
    }
}

extension OrderViewModel {
    
    func createCategoriesDictionary() {
        treeConditionFilter.append("All")
        categories.forEach({ cat in
            categoriesDic[cat.id] = cat.name
            
            if !treeConditionFilter.contains(cat.name) && cat.name.lowercased() != "tree sign" {
                treeConditionFilter.append(cat.name)
            }
        })
        
        getTreeSignProduct()
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
    
    func activateTreeSign(is isActivated: Bool ,for product: Product) {
        if let index = products.firstIndex(where: {$0.product.id == product.id}) {
            products[index].isSignActivated = isActivated
        }
    }
    
    func createTreeSignOrder(for userID: Int64) -> Order {
        var orderLines: [OrderLine] = []
        
        if let treeSign = treeSign {
            orderLines.append(OrderLine(id: nil, orderId: nil, productId: treeSign.id, price: nil, vat: nil, quantity: 1))
        }
        
        return Order(id: nil, paymentRedirectLink: PaymentURL.url, paymentStatus: nil, orderStatus: nil, userId: userID, createdAt: nil, orderLines: orderLines)
    }
}

extension OrderViewModel {
    
    func createTreeSpeciesFilter() {
        treeSpeciesFilter.append("All")
        availableProducts.forEach({ product in
            if !treeSpeciesFilter.contains(product.name) && product.name.lowercased() != "tree sign" {
                treeSpeciesFilter.append(product.name)
            }
        })
    }
}

