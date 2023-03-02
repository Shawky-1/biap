//
//  HomeVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation


class homeVM: ViewModel{
    
    func viewDidLoad() {
    }
    var bindResultToHomeView:(() -> ()) = {}
    var listOfBrands:brands!{
        didSet{
            bindResultToHomeView()
        }
    }
    func getbrands(){
        NetworkManger.fetchBrand { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let product):
                self.listOfBrands = product
    
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}
