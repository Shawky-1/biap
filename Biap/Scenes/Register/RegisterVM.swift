//
//  RegisterVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 05/03/2023.
//

import Foundation

class RegisterVM: ViewModel {
    func viewDidLoad() {
        //
    }
    
    
    var didRegister: ((Result<Customer, Error>) -> ())?
    
    func createCustomer(customer: Customer) {
        NetworkManger.CreateCustomer(customer: customer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customer):
                self.didRegister?(.success(customer))
            case .failure(let error):
                self.didRegister?(.failure(error))
            }
        }
    }
    
    func validateRegistrationFields(firstName: String?, lastName: String?, email: String?, password: String?, confirmPassword: String?, phone: String?) -> String? {
        let arrValidationModel: [ValidationModel] = [
            ValidationModel(validation: .msgRange , value: firstName?.trim, message: "Please enter your first name."),
            ValidationModel(validation: .msgRange , value: lastName?.trim, message: "Please enter your last name."),
            ValidationModel(validation: .email , value: email?.trim, message: CBlankEmail),
            ValidationModel(validation: .password , value: password?.trim, message: CBlankPswd),
            ValidationModel(validation: .mobileNumber , value: phone?.trim, message: CBlankPhoneNumber)
        ]
        
        if !MIValidation.isValidData(arrValidationModel) {
            return "Please enter valid information in all fields."
        }
        
        if password != confirmPassword {
            return "Passwords do not match."
        }
        
        return nil
    }
    
}



enum NetworkError: Error {
    case validationError(message: String)
    case otherError(message: String)
}
