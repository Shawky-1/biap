//
//  AddressesVM.swift
//  Biap
//
//  Created by Bassant on 10/03/2023.
//

import Foundation

class AddressesVM{
    
    var getAddress: (() -> ()) = {}
    
    var customerAdr :Address!{
        didSet{
            getAddress()
        }
    }
    
//    func createAddress(adr: Address) {
//        NetworkManger.CreateAddress(address: adr) { [weak self] (result: Address?) in
//            self?.customerAdr = result
//        }
//    }
}
