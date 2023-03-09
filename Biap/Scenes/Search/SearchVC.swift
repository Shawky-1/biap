////
////  SearchVC.swift
////  Biap
////
////  Created by Ahmed Shawky on 06/03/2023.
////
//
//import UIKit
//
//class SearchVC: UISearchContainerViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    var viewModel: SearchViewModel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self
//
//        searchBar.delegate = self
//
//        viewModel.onProductsFiltered = { [weak self] in
//            self?.tableView.reloadData()
//        }
//    }
//}
//
//extension SearchVC: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfProducts()
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
//
//        let product = viewModel.product(at: indexPath.row)
//
//        cell.textLabel?.text = product.name
//        cell.detailTextLabel?.text = "\(product.price) USD"
//
//        return cell
//    }
//}
//
//extension SearchVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.filterProducts(by: searchText)
//    }
//}
