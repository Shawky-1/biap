//
//  NewAddress.swift
//  Biap
//
//  Created by Bassant on 11/03/2023.
//

import UIKit

class NewAddress: UIViewController {
    
    
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    var viewModel: NewAddressVM?
    var addr:Address?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewAddressVM()
        
    }

    @IBAction func addAddress(_ sender: Any) {
        
        addr = Address(customerID: 6869254013233, Address1: addressTF.text, City: cityTF.text, Country: countryTF.text)
        viewModel?.createAddress(adr: addr!)
        self.navigationController?.popViewController(animated: true)
    }
    
}
