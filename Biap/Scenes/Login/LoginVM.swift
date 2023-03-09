//
//  LoginVM.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//

import Foundation

class LoginVM: ViewModel {
    let validator = LoginValidator()
    var customer: Customer?
    var didLogin: ((Result<String, Error>) -> ())?
    
    func viewDidLoad() {
        //Setup
        
    }
    func login(email: String, password: String) {
        do {
            try validator.validate(email: email, password: password)
            fetchLogin(email: email, password: password)
        } catch let error {
            didLogin?(.failure(error))
        }
    }
    
    private func fetchLogin(email: String, password: String) {
        NetworkManger.searchCustomer(email: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let customer):
                self.customer = customer
                if self.checkLogin(customer: customer, password: password) {
                    self.didLogin?(.success("Login successful"))
                } else {
                    self.didLogin?(.failure(LoginError.invalidPassword))
                }
                
            case .failure(let error as AppErrors):
                print(error.localizedDescription)
                //                self.errorLbl.text = error.localizedDescription
            case .failure(let error):
                self.didLogin?(.failure(error))
            }
        }
    }
    
    private func checkLogin(customer: Customer, password: String) -> Bool {
        return customer.note == password
    }
    
    func storeCustomer(){
        UserDefaults.standard.setValue(self.customer?.email, forKey: "email")
        UserDefaults.standard.setValue(self.customer?.firstName, forKey: "firstName")
        UserDefaults.standard.setValue(self.customer?.lastName, forKey: "lastName")
        UserDefaults.standard.setValue(self.customer?.phone, forKey: "phone")
    }
}


