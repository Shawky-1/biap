//
//  AddressesVM.swift
//  Biap
//
//  Created by Bassant on 10/03/2023.
//

import Foundation

class AddressesVM{
    
    var bindResultToAddressesView:(() -> ()) = {}
    
    var listOfaddresses:ListOfAddresses!{
        didSet{
            bindResultToAddressesView()
        }
    }
    
    func getListOfAddresses(url:String){
        NetworkManger.fetchAddresses(url: url) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let addresses):
                self.listOfaddresses = addresses
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
