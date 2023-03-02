//
//  ProductsView.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import UIKit

class ProductsView: UIViewController {
    
  
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var vendor:String = ""
    
    var viewModel:productVM!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = productVM()
        let termVendor = vendor.replacingOccurrences(of: " ", with: "+")
        viewModel.getSProduct(vendor: termVendor)
        viewModel.bindResultToProductView = {[weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                
            }
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

extension ProductsView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listOfProducts?.products.count ?? 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.productName.text = viewModel.listOfProducts?.products[indexPath.row].title
        cell.productPrice.text = viewModel.listOfProducts?.products[indexPath.row].variants?[0].price
        let productImageUrl = URL(string: viewModel.listOfProducts?.products[indexPath.row].images?[0].src ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        return cell
    }
    
    
}

extension ProductsView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 150, height: 150)
        return CGSize(width: collectionView.frame.size.width/2.1,height: collectionView.frame.size.height/3)
    }
}
