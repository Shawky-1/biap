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
    let searchBar = UISearchBar()
    let currency = UserDefaults.standard.string(forKey: "currency") ?? ""
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        cartIndicator()
    }
    
    
    
    func setupUI(){
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
    }
    
    func cartIndicator(){
       let products = try! Realm().objects(Cart.self)
        
        //serarch button
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass") , style: .plain, target: self, action: #selector(searchButton))
        searchButton.tintColor = .label
        
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
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem.init(
            customView: rightBarButton),searchButton]
    }
    
    @objc func cartButton(sender:UIBarButtonItem){
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func searchButton(sender:UIBarButtonItem){
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItems = nil
        searchBar.becomeFirstResponder()
 
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
        if currency == "USD" || currency == ""{
            cell.productPrice.text = filteredProducts?.products[indexPath.row].variants?[0].price
        }else{
            let price = filteredProducts?.products[indexPath.row].variants?[0].price
            let egp_Price =  (((price)! as NSString).doubleValue) * 30
            cell.productPrice.text = String(format: "%.2f", egp_Price)
        }
       
        let productImageUrl = URL(string: filteredProducts?.products[indexPath.row].images[0].src ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        if currency == "USD" || currency == ""{
            cell.Currency.text = "USD"
        }else{
            cell.Currency.text = currency
        }
       
        
        
        //save object to favorites
        cell.bindAddActionToTableView = {[weak self] in
            guard let self = self else {return}
            let obj = Favorite()
            obj.name = self.filteredProducts?.products[indexPath.row].title
            obj.image = self.filteredProducts?.products[indexPath.row].images[0].src
            if self.currency == "USD"||self.currency == ""{
                obj.price = self.viewModel.priceArr[indexPath.row]
            }
            else{
                obj.price = (self.viewModel.priceArr[indexPath.row] * 30)
            }
            obj.currency = cell.Currency.text
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
        vc.id = filteredProducts?.products[indexPath.row].id ?? 0
        vc.price = viewModel.priceArr[indexPath.row]
        //vc.variantId = filteredProducts?.products[indexPath.row].variants?[0].id ?? 0
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        searchBar.text = ""
        filteredProducts = viewModel.listOfProducts
        collectionView.reloadData()
        cartIndicator()
    }
    
}



