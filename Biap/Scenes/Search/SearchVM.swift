//
//  SearchVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 06/03/2023.
//

import Foundation


//class SearchVM: ViewModel {
//    func viewDidLoad() {
//        //
//    }
//    
//    private var products: [Product]
//    private var filteredProducts: [Product]
//
//    var onProductsFiltered: (() -> Void)?
//
//    init(products: [Product]) {
//        self.products = products
//        self.filteredProducts = products
//    }
//
//    func filterProducts(by searchQuery: String) {
//        if searchQuery.isEmpty {
//            filteredProducts = products
//        } else {
//            filteredProducts = products.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
//        }
//        onProductsFiltered?()
//    }
//
//    func numberOfProducts() -> Int {
//        return filteredProducts.count
//    }
//
//    func product(at index: Int) -> Product {
//        return filteredProducts[index]
//    }
//}
