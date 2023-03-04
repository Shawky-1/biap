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
    var timer: Timer?
    var currentCellIndex = 0
    
    override func viewDidLoad() {
        viewModel = homeVM()
        setupUI()
        viewModel.getCoupons()
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
        collectionView.register(UINib(nibName: "CouponsCell", bundle: nil), forCellWithReuseIdentifier: "CouponsCell")
        startTimer()
        
    }
    
    
    private lazy var compositionalLayoutHelper: HomeCompositionalLayoutHelper = {
        HomeCompositionalLayoutHelper()
    }()
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(slideToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func slideToNextCell(){
        if currentCellIndex < viewModel.adsArr.count-1 {
            currentCellIndex += 1
        }else{
            currentCellIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    

}

extension HomeVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            
        case 0: return viewModel.adsArr.count
        case 1: return viewModel.listOfBrands?.smart_collections.count ?? 1
        default: return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        switch indexPath.section{
        case 0:

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponsCell", for: indexPath) as! CouponsCell
            cell.couponImage.image = UIImage(named: viewModel.adsArr[indexPath.row].image!)
            return cell

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

        switch (indexPath.section){
        case 0:
            let pasteboard = UIPasteboard.general
            pasteboard.string = viewModel.adsArr[indexPath.row].code
        case 1:
            let VC = ProductsView(nibName: "ProductsView", bundle: nil)
            VC.vendor =  viewModel.listOfBrands?.smart_collections[indexPath.row].title ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        default:
            break
        }

    }
    
}

