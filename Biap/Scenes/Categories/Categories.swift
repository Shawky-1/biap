//
//  Categories.swift
//  Biap
//
//  Created by Abdelrahman on 03/03/2023.
//

import UIKit

class Categories: UIViewController {

    
    var viewModel:productVM!
 
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setupUI()
        viewModel = productVM()
        let url = urls.categoriesUrl()
        viewModel.getSProduct(url:url)
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
                self.collectionView.reloadData()
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
        return viewModel.productTypesArr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        
        cell.productName.text = viewModel.productTypesArr[indexPath.row]
      
        return cell
    }
    
    
}

extension Categories:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: (collectionView.bounds.width)-20, height: collectionView.bounds.height/4)
    }
}


extension Categories: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = productOfCategory(nibName: "productOfCategory", bundle: nil)
        vc.productType = viewModel.productTypesArr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
