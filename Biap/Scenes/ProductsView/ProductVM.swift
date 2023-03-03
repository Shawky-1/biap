//
//  ProductVM.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import Foundation



class productVM{
    var bindResultToProductView:(() -> ()) = {}
    var listOfProducts:product?{
        didSet{
            bindResultToProductView()
        }
    }
    
    
    func getSProduct(url:String,vendor:String){
        NetworkManger.fetchSPRODUCT(url:url,vendor: vendor) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let product):
                self.listOfProducts = product
                
                //print(self.listOfProducts?.products)
                //print(self.listOfBrands!.smart_collections[0].image.src!)
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}



