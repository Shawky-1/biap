//
//  AddressesVM.swift
//  Biap
//
//  Created by Bassant on 10/03/2023.
//

import Foundation

class AddressesVM{
    
    var bindResultToAddressesView:(() -> ()) = {}
    var deletedAddress:(() -> ()) = {}
    
    var listOfaddresses:ListOfAddresses!{
        didSet{
            bindResultToAddressesView()
        }
    }
    
    var addressToDelete:Address!{
        didSet{
            deletedAddress()
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
    
    func deleteAddress(address: Address){
        NetworkManger.deleteAddress(address: address) { result in
            switch(result){
            case .success(_):
                self.addressToDelete = address
                print("address deleted")
            case .failure(let error):
                print(error)
            }
        }
    }
}
