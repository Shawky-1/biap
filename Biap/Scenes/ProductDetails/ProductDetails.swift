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
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var selectSize: UILabel!
    @IBOutlet weak var selectColor: UILabel!
    @IBOutlet weak var descriprion: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var favButton: UIButton!
    let myDropDown = DropDown()
    var viewModel:productVM!
    var id:Int = 0
    var productN = ""
    var price = 0.0
    var desc:String = ""
    var exist = false
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = productVM()
        setupUI()
        let url = urls.productDetailsUrl(id: id)
        viewModel.fetchSingleProduct(url: url)
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
                
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.imgArr.count
            }
        }
        productName.text = productN
        productPrice.text = String(format: "%.2f", price)
        descriprion.text = desc
        descriprion.isEditable = false
    }
    
    
    
    
    
    @IBAction func selectSizeAction(_ sender: Any) {
        myDropDown.anchorView = sender as? any AnchorView
        myDropDown.dataSource = viewModel.sizeArr
        myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.direction = .bottom
        myDropDown.selectionAction = {(index: Int, item:String) in
            self.selectSize.text = self.viewModel.sizeArr[index]
            self.selectSize.textColor = nil
        }
        myDropDown.show()
    }
    
    
    @IBAction func selectColorAction(_ sender: Any) {
        myDropDown.anchorView = sender as? any AnchorView
        myDropDown.dataSource = viewModel.colorArr
        myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.direction = .bottom
        myDropDown.selectionAction = {(index: Int, item:String) in
            self.selectColor.text = self.viewModel.colorArr[index]
            self.selectColor.textColor = nil
        }
        myDropDown.show()
    }
    
    
    
    func setupUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",image: UIImage(systemName: "cart"), target: self,action: #selector(cartButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        addButton.cornerRadius = addButton.bounds.height / 2
        collectionView.register(UINib(nibName: "ProductDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCell")
    }
    
    //bar button
    @objc func cartButton(sender:UIBarButtonItem){
        
    }
    
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        let obj = Cart()
        obj.name = productName.text
        obj.color = selectColor.text
        obj.size = selectSize.text
        obj.image = viewModel.imgArr[0]
        obj.price = price
        realm.beginWrite()
        realm.add(obj)
        try! realm.commitWrite()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        if exist{
            (sender as AnyObject).setImage(UIImage(systemName: "heart"), for: .normal)
           
       }else{
           (sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
           
       }
        exist = !exist
    }
    
    
    
    private lazy var compositionalLayoutHelper: HomeCompositionalLayoutHelper = {
        HomeCompositionalLayoutHelper()
    }()

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
        //return CGSize(width: 150, height: 150)
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
