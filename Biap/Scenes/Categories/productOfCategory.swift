//
//  productOfCategory.swift
//  Biap
//
//  Created by Abdelrahman on 04/03/2023.
//

import UIKit

class productOfCategory: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var productType = ""
    var viewModel:productVM!
    var filteredProducts:products?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
        viewModel = productVM()
        let url = urls.productsOfCategory(productType: productType)
        viewModel.getSProduct(url:url)
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
            self.filteredProducts = self.viewModel.listOfProducts
                self.collectionView.reloadData()
        }
       
    }

    func setupUI(){
        //collectionView.collectionViewLayout = compositionalLayoutHelper.createCompositionalLayout()
//        collectionView.registerCell(cellClass: BrandsCell.self)
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
    }
    
    private lazy var compositionalLayoutHelper: HomeCompositionalLayoutHelper = {
        HomeCompositionalLayoutHelper()
    }()


}
extension productOfCategory:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts?.products.count ?? 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.productName.text = filteredProducts?.products[indexPath.row].title
        cell.productPrice.text = filteredProducts?.products[indexPath.row].variants?[0].price
        let productImageUrl = URL(string: filteredProducts?.products[indexPath.row].images[0].src ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        
        return cell
    }
    
    
}

extension productOfCategory:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/2.1),height: collectionView.frame.size.height/2.8)
    }
}


extension productOfCategory: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ProductDetails(nibName: "ProductDetails", bundle: nil)
        
        
        vc.id =  viewModel.listOfProducts?.products[indexPath.row].id ?? 0
        vc.productN = viewModel.listOfProducts?.products[indexPath.row].title ?? ""
        vc.price = viewModel.listOfProducts?.products[indexPath.row].variants?[0].price ?? ""
        vc.desc = viewModel.listOfProducts?.products[indexPath.row].body_html ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension productOfCategory:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = viewModel.listOfProducts
            collectionView.reloadData()
        } else {
            filteredProducts!.products = viewModel.listOfProducts!.products.filter{
                $0.title!.lowercased().contains(searchText.lowercased()) }
            collectionView.reloadData()
        }
    }
    
}


