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
            collectionView.register(UINib(nibName: "HeaderView", bundle: nil ), forSupplementaryViewOfKind: "header" , withReuseIdentifier: "HeaderView")
        }
    }
    
    
    var viewModel:ViewModel?
    var brand:Brand?
    override func viewDidLoad() {
        viewModel = homeVM()
        setupUI()
        NetworkManger.getAllBrands {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let brands):
                self.brand = brands
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupUI(){
        collectionView.collectionViewLayout = compositionalLayoutHelper.createCompositionalLayout()

    }
    
    
    private lazy var compositionalLayoutHelper: HomeCompositionalLayoutHelper = {
        HomeCompositionalLayoutHelper()
    }()

    

}

extension HomeVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return brand?.brands.count ?? 0
        default: return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 1:
            return UICollectionViewCell()
        default: return UICollectionViewCell()
        }
    }
    
    
}

