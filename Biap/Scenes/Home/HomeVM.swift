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
    
    
    func fetchBrands(){
        NetworkManger.getAllBrands { result in
            switch result{
            case .success(let brands):
                print(brands)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
