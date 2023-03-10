//
//  ProductVM.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import Foundation




class productVM{
    
    
    var productTypesArr:[String] = []
    var priceArr:[Double] = [0.0]
    var bindResultToProductView:(() -> ()) = {}
    var listOfProducts:products?{
        didSet{
            bindResultToProductView()
        }
    }
    
  
    
    
    func getSProduct(url:String){
        NetworkManger.fetchProducts(url:url) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let product):
                self.listOfProducts = product
                for each in self.listOfProducts!.products{
                    if self.productTypesArr.contains(each.product_type!) == false{
                        self.productTypesArr.append(each.product_type ?? "")
                    }
                        
                }
                self.priceArr.removeAll()
                for each in self.listOfProducts!.products{
                    let c = each.variants![0]
                    self.priceArr.append(((c.price)! as NSString).doubleValue)
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
  
    
    

    
    }




