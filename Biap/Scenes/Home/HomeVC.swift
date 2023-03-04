//
//  ViewController.swift
//  Biap
//
//  Created by Ahmed Shawky on 28/02/2023.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HeaderView", bundle: nil ), forSupplementaryViewOfKind: "header" , withReuseIdentifier: "HeaderView")
        }
    }
    
    
    var viewModel:homeVM!
    
    override func viewDidLoad() {
        viewModel = homeVM()
        setupUI()
        viewModel.getbrands()
        viewModel.bindResultToHomeView = {[weak self] in
            guard let self = self else {return}
            self.collectionView.reloadData()
        }
    }
    
    func setupUI(){
        collectionView.collectionViewLayout = compositionalLayoutHelper.createCompositionalLayout()
//        collectionView.registerCell(cellClass: BrandsCell.self)
        collectionView.register(UINib(nibName: "BrandsCell", bundle: nil), forCellWithReuseIdentifier: "BrandsCell")
        
    }
    
    
    private lazy var compositionalLayoutHelper: HomeCompositionalLayoutHelper = {
        HomeCompositionalLayoutHelper()
    }()

    

}

extension HomeVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            
        case 0: return 0
        case 1: return viewModel.listOfBrands?.smart_collections.count ?? 1
        default: return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        switch indexPath.section{
        case 0:
            
            return UICollectionViewCell()
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCell
            cell.brandName.text = viewModel.listOfBrands?.smart_collections[indexPath.row].title
            let brandImageUrl = URL(string: viewModel.listOfBrands?.smart_collections[indexPath.row].image.src ?? "")
            cell.brandImageV.kf.setImage(with: brandImageUrl)
            return cell
        
        default:
           
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "HeaderView", for: indexPath)as? HeaderView else{
            return UICollectionReusableView()
        }
        switch indexPath.section{
        case 0:
            view.headerLbl.text = "Coupones"
            view.didClickViewAll = { id in
                print("case 0")
            }
        case 1:
            view.headerLbl.text = "Brands"
            view.didClickViewAll = { id in
                print("case 1")
            }
        default:
            view.headerLbl.text = ""
            view.viewAllBtn.isHidden = true

        }
        return view
    }
}
    

extension HomeVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let VC = ProductsView(nibName: "ProductsView", bundle: nil)
        
        
        VC.vendor =  viewModel.listOfBrands?.smart_collections[indexPath.row].title ?? ""
        VC.hidesBottomBarWhenPushed = true
        
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

