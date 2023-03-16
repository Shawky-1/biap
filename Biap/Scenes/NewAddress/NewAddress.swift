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
        viewModel?.getAddress = {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @IBAction func addAddress(_ sender: Any) {
        
        addr = Address(customerID: UserDefaults.standard.integer(forKey: "id"), Address1: addressTF.text, City: cityTF.text, Country: countryTF.text)
        
        let validationArr: [ValidationModel] = [
            ValidationModel(validation: .notEmpty , value: countryTF.text, message: "Please enter country"),
            ValidationModel(validation: .notEmpty , value: cityTF.text, message: "Please enter city"),
            ValidationModel(validation: .notEmpty , value: addressTF.text, message: "please enter your address"),
            ValidationModel(validation: .mobileNumber , value: phoneTF.text, message: CBlankPhoneNumber)]
        
        if MIValidation.isValidData(validationArr){
            
            viewModel?.createAddress(adr: addr!)
        }
    }
    
}
