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
        let editedVendor = vendor.replacingOccurrences(of: " ", with: "+")
        let url = urls.productsViewUrl(vendor: editedVendor)
        viewModel.getSProduct(url:url)
        viewModel.bindResultToProductView = {[weak self] in
                self?.collectionView.reloadData()
        }
    }
    
    
    func setupUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",image: UIImage(systemName: "cart"), target: self,action: #selector(cartButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        
    }
    
    @objc func cartButton(sender:UIBarButtonItem){
        
            
        
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
        
        cell.productPrice.text = String(format: "%.2f", (viewModel.priceArr[indexPath.row]))
        let productImageUrl = URL(string: viewModel.listOfProducts?.products[indexPath.row].images[0].src ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        return cell
    }
    
    
}

extension ProductsView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 150, height: 150)
        return CGSize(width: ((collectionView.frame.size.width)-10)/2,height: collectionView.frame.size.height/2.8)
    }
}


extension ProductsView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ProductDetails(nibName: "ProductDetails", bundle: nil)
        
        
        vc.id =  viewModel.listOfProducts?.products[indexPath.row].id ?? 0
        vc.productN = viewModel.listOfProducts?.products[indexPath.row].title ?? ""
        vc.price = viewModel.priceArr[indexPath.row]
        vc.desc = viewModel.listOfProducts?.products[indexPath.row].body_html ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


