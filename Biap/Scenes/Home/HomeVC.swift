//
//  ViewController.swift
//  Biap
//
//  Created by Ahmed Shawky on 28/02/2023.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HeaderView", bundle: nil ), forSupplementaryViewOfKind: "header" , withReuseIdentifier: "HeaderView")
        }
    }
    
    
    var viewModel:ViewModel?
    var brands:[Brand.SmartCollections]?
    override func viewDidLoad() {
        viewModel = homeVM()
        setupUI()
        NetworkManger.getAllBrands {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let brand):
                self.brands = brand.brands
                print(self.brands)
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
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
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            
        case 0: return 20
        case 1: return 20
        case 2: return 20
        default: return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCell

        switch indexPath.section{
        case 0:
            cell.imgView.image = #imageLiteral(resourceName: "HD-wallpaper-sea-side-top-view-top-view-sea-side-nature-background-ios-android-apple")
            return cell
        case 1:
            cell.imgView.image = #imageLiteral(resourceName: "HD-wallpaper-sea-side-top-view-top-view-sea-side-nature-background-ios-android-apple")
            return cell
        case 2:
            cell.imgView.image = #imageLiteral(resourceName: "HD-wallpaper-sea-side-top-view-top-view-sea-side-nature-background-ios-android-apple")
            return cell
        default:
            cell.imgView.image = #imageLiteral(resourceName: "HD-wallpaper-sea-side-top-view-top-view-sea-side-nature-background-ios-android-apple")
            return cell
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
    
}

