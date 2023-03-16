//
//  ProductDetails.swift
//  Biap
//
//  Created by Abdelrahman on 03/03/2023.
//

import UIKit
import DropDown
import RealmSwift

class ProductDetails: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.register(UINib(nibName: "ProductDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCell")

        }
    }
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var selectSize: UILabel!
    @IBOutlet weak var selectColor: UILabel!
    @IBOutlet weak var descriprion: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var Currency: UILabel!
    
    let myDropDown = DropDown()
    var viewModel:ProductDetailsVM!
    var id:Int = 0
    var variantId:Int = 0
    var price = 0.0
    var exist = false
    var filteredId = 0
    let currency = UserDefaults.standard.string(forKey: "currency") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProductDetailsVM()
        setupUI()
        viewModel.fetchSingleProduct(url: urls.productDetailsUrl(id: id))
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.imgArr.count
                self.productName.text = self.viewModel.singleProduct?.product.title
                if self.currency == "USD" || self.currency == ""{
                    self.productPrice.text = self.viewModel.singleProduct?.product.variants![0].price
                }else{
                    let price = self.viewModel.singleProduct?.product.variants![0].price
                    let egp_Price =  (((price)! as NSString).doubleValue) * 30
                    self.productPrice.text = String(egp_Price)
                }
                self.descriprion.text = self.viewModel.singleProduct?.product.body_html
                //self.Currency.text = self.currency
                
            
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //favorite button appearence
        for item in try! Realm().objects(Favorite.self).filter("productId == %@",id){
            if id == item.productId{
                favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                exist = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartIndicator()
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
    
    
    @IBAction func selectSizeAction(_ sender: Any) {
        viewModel.dropDown(array: viewModel.sizeArr, sender: sender, DropDown: myDropDown, label: selectSize)
        myDropDown.selectionAction = {(index: Int, item:String) in
            self.selectSize.text = self.viewModel.sizeArr[index]
            self.selectSize.textColor = nil
            DispatchQueue.main.async {
                for i in 0..<self.viewModel.sizeArr.count{
                    if  self.selectSize.text == self.viewModel.sizeArr[i]{
                        self.variantId = self.viewModel.vartantsArr[i]
                    }
                }
            }
        }
    }
    
    
    @IBAction func selectColorAction(_ sender: Any) {
        viewModel.dropDown(array: viewModel.colorArr, sender: sender, DropDown: myDropDown, label: selectColor)
        myDropDown.selectionAction = {(index: Int, item:String) in
            self.selectColor.text = self.viewModel.colorArr[index]
            self.selectColor.textColor = nil
  
        }
    }
    
    
    
    func setupUI(){
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        self.title = "Product Details"
        self.ratingView.configureWithRating(rating: Int.random(in: 0...5), style: .full)
        addButton.cornerRadius = addButton.bounds.height / 2
        pageControl.cornerRadius = pageControl.bounds.height / 2
        collectionView.register(UINib(nibName: "ProductDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCell")
        descriprion.isEditable = false
        descriprion.isSelectable = false
        if currency == "USD" || currency == ""{
            self.Currency.text = "USD"
        }else{
            self.Currency.text = currency
        }
    }
    
    //bar button
    @objc func cartButton(sender:UIBarButtonItem){
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        
        if selectSize.text == "Select Size" || selectColor.text == "Select Color"{
            let alert:UIAlertController = UIAlertController(title: "Warning!", message: "Please select Size and Color", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert,animated: true,completion: nil)
            
        }else{
            let products = try! Realm().objects(Cart.self)
            for item in products.filter("variantId == %@",variantId){
                filteredId = item.variantId
            }
            if filteredId == 0{
                let obj = Cart()
                obj.name = self.productName.text
                obj.color = self.selectColor.text
                obj.size = self.selectSize.text
                obj.image = self.viewModel.imgArr[0]
                if self.currency == "USD" || currency == ""{
                    let usdPrice = (((self.viewModel.singleProduct?.product.variants![0].price)! as NSString).doubleValue)
                    obj.price = usdPrice
                }else{
                    let price = self.viewModel.singleProduct?.product.variants![0].price
                    let egp_Price =  (((price)! as NSString).doubleValue) * 30
                    obj.price = egp_Price
                }
                obj.currency = self.Currency.text
                obj.variantId = variantId
                obj.productId = self.id
                obj.quantity = 1
                RealmManager.saveDataToCart(obj: obj)
                
                let alert:UIAlertController = UIAlertController(title: "", message: "Item is added successfully to your shopping cart", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert,animated: true,completion: nil)
                cartIndicator()
            }else{
                let alert:UIAlertController = UIAlertController(title: "Warning", message: "Item is already exist in your shopping cart", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert,animated: true,completion: nil)
            }
            filteredId = 0
        }
    }
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        if exist{
            (sender as AnyObject).setImage(UIImage(systemName: "heart"), for: .normal)
            RealmManager.deleteDatafromFavorites(id: id)
       }else{
           (sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
           let obj = Favorite()
           obj.name = self.productName.text
           obj.color = self.selectColor.text
           obj.size = self.selectSize.text
           obj.image = self.viewModel.imgArr[0]
           if self.currency == "USD" || currency == ""{
               let usdPrice = (((self.viewModel.singleProduct?.product.variants![0].price)! as NSString).doubleValue)
               obj.price = usdPrice
           }else{
               let price = self.viewModel.singleProduct?.product.variants![0].price
               let egp_Price =  (((price)! as NSString).doubleValue) * 30
               obj.price = egp_Price
           }
           obj.currency = self.Currency.text
           obj.variantId = self.variantId
           obj.productId = self.id
           RealmManager.saveDataToFavorites(obj: obj)
       }
        exist = !exist
    }

}

extension ProductDetails:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imgArr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCell", for: indexPath) as! ProductDetailsCell
        
        let productImageUrl = URL(string: viewModel.imgArr[indexPath.row])
        cell.imageView.kf.setImage(with: productImageUrl)
        
      
        return cell
    }
    
    
}

extension ProductDetails:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.bounds.width)),height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x) / (scrollView.frame.width)
        pageControl.currentPage = Int(index)
      
    }
}
