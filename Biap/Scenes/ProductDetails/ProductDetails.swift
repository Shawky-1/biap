//
//  ProductDetails.swift
//  Biap
//
//  Created by Abdelrahman on 03/03/2023.
//

import UIKit
import DropDown

class ProductDetails: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
  
    @IBOutlet weak var selectSize: UILabel!
    
    @IBOutlet weak var selectColor: UILabel!
    
    @IBOutlet weak var descriprion: UITextView!
    
    let myDropDown = DropDown()
   
    
    var viewModel:productVM!
    var id:Int = 0
    
    var productN = ""
    var price = ""
    var desc:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = productVM()
        setupUI()
        let url = urls.productDetailsUrl(id: id)
        viewModel.fetchSingleProduct(url: url)
        viewModel.bindResultToProductView = {[weak self] in
            guard let self = self else {return}
                self.collectionView.reloadData()
        }
        productName.text = productN
        productPrice.text = price
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
            self.selectSize.textColor = .black
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
            self.selectColor.textColor = .black
        }
        myDropDown.show()
    }
    
    
    
    func setupUI(){
        //collectionView.collectionViewLayout = compositionalLayoutHelper.createCompositionalLayout()
//        collectionView.registerCell(cellClass: BrandsCell.self)
        collectionView.register(UINib(nibName: "ProductDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCell")
        
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
}


/*extension ProductDetails: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ProductDetails(nibName: "ProductDetails", bundle: nil)
        
        
        //VC.vendor =  viewModel.listOfBrands?.smart_collections[indexPath.row].title ?? ""
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}*/
