//
//  SearchResultsVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import Foundation

class SearchResultsVM: ViewModel{
    var resultsLoaded: (() -> ())?
    var searchableItems: [properies] = []
    var filteredItems: [properies] = []

    func viewDidLoad() {
        fetchProducts()
    }
    private func fetchProducts(){
        NetworkManger.fetchProducts(url: urls.categoriesUrl()) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let product):
                self.searchableItems = product.products
                self.filteredItems = product.products
                self.resultsLoaded?()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func filterItems(for searchText: String) {
        if searchText.isEmpty {
            // If search text is empty, show all items
            filteredItems = searchableItems
            self.resultsLoaded?()
        } else {
            // Filter the items based on the search text
            filteredItems = searchableItems.filter { item in
                guard let title = item.title else {
                    return false
                }
                return title.lowercased().contains(searchText.lowercased())
            }
            self.resultsLoaded?()
        }
    }
}
