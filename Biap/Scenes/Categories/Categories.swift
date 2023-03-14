//
//  Categories.swift
//  Biap
//
//  Created by Abdelrahman on 03/03/2023.
//

import UIKit
import Kingfisher
import Reachability
import RealmSwift

class Categories: UIViewController {

    
    var viewModel:productVM!
    let imagesArr = ["Acs","Shoes","Tshirt"]
 
    
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
        setupUI()
        viewModel = productVM()
        viewModel.getSProduct(url:urls.categoriesUrl())
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
                self.collectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartIndicator()
    }
    
    func checkConnection(){
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.collectionView.isHidden = true
            self.imagePlaceHolder.isHidden = false
      
        }
    }
    
    func cartIndicator(){
       let products = try! Realm().objects(Cart.self)
        
        let cartButtonn = SSBadgeButton()
        cartButtonn.frame = CGRect(x: 22, y: -05, width: 20, height: 20)
        //cartIcon.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            cartButtonn.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cartButtonn.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            cartButtonn.addTarget(self, action: #selector(cartButton), for: .touchUpInside)
        cartButtonn.badge = String(products.count)
        cartButtonn.tintColor = .label
        
        if products.isEmpty{
            cartButtonn.isHidden = true
        }
    
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightBarButton.addTarget(self, action: #selector(self.cartButton), for: .touchUpInside)
        rightBarButton.setImage(UIImage(systemName: "cart"), for: .normal)
        rightBarButton.tintColor = .label
        rightBarButton.addSubview(cartButtonn)

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                customView: rightBarButton)
    }
    
  
    
    func setupUI(){
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        collectionView.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCell")
        self.title = "Categories"
    }
    
    @objc func cartButton(sender:UIBarButtonItem){
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
        cell.imageView.image = UIImage(named: imagesArr[indexPath.row])
     
      
        return cell
    }
    
    
}

extension Categories:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: (collectionView.bounds.width)-20, height: collectionView.bounds.height/5)
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
