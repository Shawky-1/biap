//
//  Categories.swift
//  Biap
//
//  Created by Abdelrahman on 03/03/2023.
//

import UIKit

class Categories: UIViewController {
    var viewModel:productVM!
    var vendor:String = ""
    var flag = true
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segCont: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
        viewModel = productVM()
        let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json"
        viewModel.getSProduct(url:url,vendor: vendor)
        viewModel.bindResultToProductView = {[weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                
            }
        }
    }
    
    
    @IBAction func segConAction(_ sender: Any) {
        
        switch (self.segCont.selectedSegmentIndex){
        case 0:
            let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json"
            viewModel.getSProduct(url:url,vendor: vendor)
            viewModel.bindResultToProductView = {[weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    
                }
            }
        case 1:
            let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json?product_type=SHOES"
            viewModel.getSProduct(url:url,vendor: vendor)
            viewModel.bindResultToProductView = {[weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    
                }
            }
        case 2:
            let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json?product_type=ACCESSORIES"
            viewModel.getSProduct(url:url,vendor: vendor)
            viewModel.bindResultToProductView = {[weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    
                }
            }
        default:
            let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json?product_type=T-SHIRTS"
            viewModel.getSProduct(url:url,vendor: vendor)
            viewModel.bindResultToProductView = {[weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    
                }
            }
        }
    }
    
    
    func setupUI(){
        //collectionView.collectionViewLayout = compositionalLayoutHelper.createCompositionalLayout()
//        collectionView.registerCell(cellClass: BrandsCell.self)
        collectionView.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCell")
        
        
    }
    
    private lazy var compositionalLayoutHelper: HomeCompositionalLayoutHelper = {
        HomeCompositionalLayoutHelper()
    }()


}


extension Categories:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listOfProducts?.products.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        
        cell.productName.text = viewModel.listOfProducts?.products[indexPath.row].variants?[0].price
        let productImageUrl = URL(string: viewModel.listOfProducts?.products[indexPath.row].images?[0].src ?? "")
        cell.imageView.kf.setImage(with: productImageUrl)
      
        return cell
    }
    
    
}

extension Categories:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 150, height: 150)
        return CGSize(width: ((collectionView.bounds.width)/3.2),height: collectionView.frame.size.height/4.9)
    }
}
