//
//  Addresses.swift
//  Biap
//
//  Created by Bassant on 10/03/2023.
//

import UIKit

class Addresses: UIViewController {
    
    var viewModel: AddressesVM?
    //var custAd = Address(customerID: 6867757629745, Address1: "zz", City: "xx", Country: "X")
    var addr:Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressesVM()
        
//        viewModel?.getAddress = { [weak self] in
//            DispatchQueue.main.async {
//                self?.addr = self?.viewModel?.customerAdr
//                //print(self?.addr!)
//            }
//        }
//
//        viewModel?.createAddress(adr: custAd)
    }


}
