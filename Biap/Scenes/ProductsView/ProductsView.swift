//
//  ProductsView.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import UIKit
import RealmSwift

class ProductsView: UIViewController {
    
  
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var vendor:String = ""
    var filteredId:Int = 0
    
    
    var viewModel:productVM!
    let realm = try! Realm()
    var filteredProducts:products?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = productVM()
        let editedVendor = vendor.replacingOccurrences(of: " ", with: "+")
        viewModel.getSProduct(url:urls.productsViewUrl(vendor: editedVendor))
        viewModel.bindResultToProductView = {[weak self] in
            self?.filteredProducts = self?.viewModel.listOfProducts
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
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentController(_ sender: Any) {
        switch segmentController.selectedSegmentIndex{
        case 0:
            filteredProducts = viewModel.listOfProducts
            collectionView.reloadData()
        case 1:
            self.filteredProducts?.products.sort{($0.variants![0].price! as NSString).doubleValue < ($1.variants![0].price! as NSString).doubleValue}
            collectionView.reloadData()
        default:
            self.filteredProducts?.products.sort{($0.variants![0].price! as NSString).doubleValue > ($1.variants![0].price! as NSString).doubleValue}
            collectionView.reloadData()
        }
    }
   
    
}

extension ProductsView:UICollectionViewDataSource{
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
        
        
        //save object to favorites
        cell.bindAddActionToTableView = {[weak self] in
            guard let self = self else {return}
            let obj = Favorite()
            obj.name = self.filteredProducts?.products[indexPath.row].title
            obj.image = self.filteredProducts?.products[indexPath.row].images[0].src
            obj.price = self.viewModel.priceArr[indexPath.row]
            obj.productId = (self.filteredProducts?.products[indexPath.row].id)!
            obj.variantId = self.filteredProducts?.products[indexPath.row].variants?[0].id ?? 0
            RealmManager.saveDataToFavorites(obj: obj)
        }
        
        //delete object from favorites
        cell.bindDeleteActionToTableView = {[weak self] in
            guard let self = self else {return}
            let filtredId = self.filteredProducts?.products[indexPath.row].id ?? 0
            RealmManager.deleteDatafromFavorites(id: filtredId)
        }
        
        //fill the button if object is exist in favorites
        let filteredProduct = self.realm.objects(Favorite.self).filter("productId == %@",self.filteredProducts?.products[indexPath.row].id ?? 0)
        for item in filteredProduct{
            self.filteredId = item.productId
        }
        if filteredId ==  self.filteredProducts?.products[indexPath.row].id{
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.exist = true
        }else{
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.filteredId = 0
        return cell
    }
    
    
}

extension ProductsView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.frame.size.width)-10)/2,height: collectionView.frame.size.height/2.8)
    }
}


extension ProductsView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ProductDetails(nibName: "ProductDetails", bundle: nil)
        vc.id =  viewModel.listOfProducts?.products[indexPath.row].id ?? 0
        vc.price = viewModel.priceArr[indexPath.row]
        vc.variantId = viewModel.listOfProducts?.products[indexPath.row].variants?[0].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ProductsView:UISearchBarDelegate{
    
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



