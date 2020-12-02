//
//  ProductViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    private let productRepository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }
}

extension ProductViewModel {
    
}
