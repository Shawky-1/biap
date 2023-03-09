//
//  HomeVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation


class homeVM: ViewModel{
    
    func viewDidLoad() {
        getbrands()
        getCoupons()
    }
    var adsArr:[coupon] = []
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
    
    func getCoupons(){
        adsArr.append(coupon(code: "VFSSW20", image: "ad1"))
        adsArr.append(coupon(code: "EFYSS10", image: "ad2"))
        adsArr.append(coupon(code: "SUVXX50", image: "ad3"))
    }
}
