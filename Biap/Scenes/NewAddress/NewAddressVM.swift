//
//  NewAddressVM.swift
//  Biap
//
//  Created by Bassant on 11/03/2023.
//

import Foundation

class NewAddressVM{
    
    var getAddress: (() -> ()) = {}
    
    var customerAdr :Address!{
        didSet{
            getAddress()
        }
    }
    
    func createAddress(adr: Address) {
        NetworkManger.CreateAddress(address: adr) { [weak self] result in
            //self?.customerAdr = result
            guard let self = self else { return }
            switch result {
            case .success(let address):
                self.customerAdr = address
                dump(address)
            case .failure(let error):
                //print(String(describing: error))
                print(error.localizedDescription)
            }
        }
    }
    
}
