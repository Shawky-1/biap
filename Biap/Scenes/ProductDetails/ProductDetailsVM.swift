//
//  ProductDetailsVM.swift
//  Biap
//
//  Created by Abdelrahman on 09/03/2023.
//

import Foundation
import DropDown

class ProductDetailsVM{
    var imgArr:[String] = []
    
    var sizeArr:[String] = []
    var colorArr:[String] = []
    var vartantsArr:[Int] = []
    var bindResultToProductView:(() -> ()) = {}
    
    //let myDropDown = DropDown()
    
    var singleProduct:singleProduct?{
        didSet{
            bindResultToProductView()
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
                
                for each in self.singleProduct!.product.variants!{
                    self.vartantsArr.append(each.id!)
                }
                //print(self.vartantsArr)
                
                
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
    
    func dropDown(array:[String],sender:Any,DropDown:DropDown,label:UILabel){
        DropDown.anchorView = sender as? any AnchorView
        DropDown.dataSource = array
        DropDown.bottomOffset = CGPoint(x: 0, y: (DropDown.anchorView?.plainView.bounds.height)!)
        DropDown.topOffset = CGPoint(x: 0, y: -(DropDown.anchorView?.plainView.bounds.height)!)
        DropDown.direction = .bottom
        
        /*DropDown.selectionAction = {(index: Int, item:String) in
            label.text = array[index]
            label.textColor = nil
            for i in 0..<self.sizeArr.count{
                if label.text == self.sizeArr[i]{
                    self.variantId = self.vartantsArr[i]
                }
            }
        }*/
        DropDown.show()
    }

}
