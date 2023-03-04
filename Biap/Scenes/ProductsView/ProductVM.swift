//
//  ProductVM.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import Foundation



class productVM{
    var imgArr:[String] = []
    
    var sizeArr:[String] = []
    var colorArr:[String] = []
    var productTypesArr:[String] = []
    var bindResultToProductView:(() -> ()) = {}
    var listOfProducts:products?{
        didSet{
            bindResultToProductView()
        }
        
    }
    
    var singleProduct:singleProduct?{
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
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    
    func fetchSingleProduct(url:String){
        NetworkManger.fetchSingleProduct(url: url) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let product):
                self.singleProduct = product
                
                for each in self.singleProduct!.product.images{
                    self.imgArr.append(each.src)
                }
                
                
                for each in self.singleProduct!.product.options{
                    if each.name == "Size"{
                        let size = each.values!
                        self.sizeArr.append(contentsOf: size)
                    }
                    if each.name == "Color"{
                        let color = each.values!
                        self.colorArr.append(contentsOf: color)
                    }
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
        }
    }




