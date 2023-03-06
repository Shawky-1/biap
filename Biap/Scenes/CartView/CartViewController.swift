//
//  CartViewController.swift
//  Biap
//
//  Created by Abdelrahman on 06/03/2023.
//

import UIKit
import RealmSwift
import Realm

class CartViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var name:String = ""
    var size:String = ""
    var color:String = ""
    var price:Double = 0.0
    var image:String = ""
    var cartArray:[Cart] = []
    var cartObj:Cart?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //try! Realm().deleteAll()
        renderData()
        collectionView.reloadData()
    }
    
    
    func renderData(){
        let products = try! Realm().objects(Cart.self)
        /*try! realm.write({
            realm.deleteAll()
        })*/
        for each in products{
            cartArray.append(each)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //cartArray.append(cartObj!)
       
        
    }


    func setupUI(){
      
        self.navigationController?.navigationBar.tintColor = UIColor.label
        collectionView.register(UINib(nibName: "CartViewCell", bundle: nil), forCellWithReuseIdentifier: "CartViewCell")
    }

}

extension CartViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartViewCell", for: indexPath) as! CartViewCell
        
        cell.productName.text = cartArray[indexPath.row].name
        cell.productSize.text = cartArray[indexPath.row].size
        cell.productColor.text = cartArray[indexPath.row].color
       
        cell.productPrice.text = String(format: "%.2f", cartArray[indexPath.row].price * ((cell.productQuantity.text)! as NSString).doubleValue)
        //collectionView.reloadData()
        let productImageUrl = URL(string: cartArray[indexPath.row].image ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
     
      
        return cell
    }
    
    
}

extension CartViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: (collectionView.bounds.width)-20, height: collectionView.bounds.height/4)
    }
}


/*extension CartViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = productOfCategory(nibName: "productOfCategory", bundle: nil)
        vc.productType = viewModel.productTypesArr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}*/

