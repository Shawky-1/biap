//
//  SearchResultsVC.swift
//  Biap
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import UIKit

class SearchResultsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.registerCellNib(cellClass: SearchCell.self)
        }
    }
    
    var viewModel: SearchResultsVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchResultsVM()
        viewModel.viewDidLoad()
        viewModel.resultsLoaded = { [weak self] in
            self?.tableView.reloadData()
        }

    }
    

}

extension SearchResultsVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.configureCell(name: viewModel.filteredItems[indexPath.row].title ?? "No name",
                           image: viewModel.filteredItems[indexPath.row].images[0].src)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let productDetailsVC = ProductDetails(nibName: "ProductDetails", bundle: nil)
        productDetailsVC.id = viewModel.filteredItems[indexPath.row].id ?? 0
        let price = viewModel.filteredItems[indexPath.row].variants?[0].price ?? ""
        productDetailsVC.price = Double(price) ?? 0.0
        productDetailsVC.variantId = viewModel.filteredItems[indexPath.row].variants?[0].id ?? 0
        productDetailsVC.hidesBottomBarWhenPushed = true
        self.present(productDetailsVC, animated: true)
//        self.navigationController?.pushViewController(productDetailsVC, animated: true)

    }
    
    
}
