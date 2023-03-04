//
//  productOfCategory.swift
//  Biap
//
//  Created by Abdelrahman on 04/03/2023.
//

import UIKit

class productOfCategory: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var productType = ""
    var viewModel:productVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
        viewModel = productVM()
        let url = urls.productsOfCategory(productType: productType)
        viewModel.getSProduct(url:url)
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
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
        return viewModel.listOfProducts?.products.count ?? 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.productName.text = viewModel.listOfProducts?.products[indexPath.row].title
        cell.productPrice.text = viewModel.listOfProducts?.products[indexPath.row].variants?[0].price
        let productImageUrl = URL(string: viewModel.listOfProducts?.products[indexPath.row].images[0].src ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        
        
        return cell
    }
    
    
}

extension productOfCategory:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 150, height: 150)
        //return CGSize(width: ((collectionView.bounds.width)/3.2),height: collectionView.frame.size.height/4.9)
        
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


