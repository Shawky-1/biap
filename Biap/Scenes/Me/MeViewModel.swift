//
//  MeViewModel.swift
//  Biap
//
//  Created by Abdelrahman on 10/03/2023.
//

import Foundation

class MeViewModel{
    var bindResultToMeView:(() -> ()) = {}
    
    
    var listOfOrders:orders!{
        didSet{
            bindResultToMeView()
        }
    }
    
    
    
    func getOrders(url:String){
        
        NetworkManger.fetchOrders(url: url, complition: { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let orders):
                self.listOfOrders = orders
                
            case .failure(let error):
                print(String(describing: error))
            }
        })
    }
}
