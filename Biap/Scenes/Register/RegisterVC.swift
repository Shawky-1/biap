//
//  RegisterVC.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var firstNameTF: TextField!
    @IBOutlet weak var lastNameTF: TextField!
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
    @IBOutlet weak var confirmPasswordTF: TextField!
    @IBOutlet weak var phoneTF: TextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var viewModel:RegisterVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegisterVM()
        viewModel.didRegister = { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(_):
                self.presentAlertViewWithOneButtonMIV(alertTitle: nil, alertMessage: "Account created!", btnOneTitle: "Ok") { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                if error is AppErrors {
                    
                    self.presentAlertViewWithOneButtonMIV(alertTitle: nil, alertMessage: "This email or phone is already in use.", btnOneTitle: "Ok") { _ in
                        self.resignFirstResponder()
                    }
                } else {
                    self.presentAlertViewWithOneButtonMIV(alertTitle: nil, alertMessage: error.localizedDescription, btnOneTitle: "Ok") { _ in
                        self.resignFirstResponder()
                    }
                }
            }
        }
        setupUI()
        
    }
    
    func setupUI(){
        self.title = "Create a new account"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        loginBtn.cornerRadius = loginBtn.bounds.height / 2
    }
    
    
    
    @IBAction func didClickLogin(_ sender: Any) {
        let arrValidationModel: [ValidationModel] = [
                    ValidationModel(validation: .msgRange , value: firstNameTF.text?.trim, message: "Please enter your first name."),
                    ValidationModel(validation: .msgRange , value: lastNameTF.text?.trim, message: "Please enter your last name."),
                    ValidationModel(validation: .email , value: emailTF.text?.trim, message: CBlankEmail),
                    ValidationModel(validation: .password , value: passwordTF.text?.trim, message: CBlankPswd),
                    ValidationModel(validation: .mobileNumber , value: phoneTF.text?.trim, message: CBlankPhoneNumber)]
                
                // Check Validation Of SignUp
                
                if MIValidation.isValidData(arrValidationModel) {
                    if passwordTF.text?.trim != confirmPasswordTF.text?.trim{
                        presentAlertViewWithOneButtonMIV(alertTitle: nil, alertMessage: "Passwords doesn't match", btnOneTitle: "Ok", btnOneTapped: nil)
                        self.view.endEditing(true)
                        return
                    }
                    let customer = Customer(email: emailTF.text?.trim ?? "",
                                            firstName: firstNameTF.text?.trim ?? "",
                                            lastName: lastNameTF.text?.trim ?? "",
                                            note: passwordTF.text?.trim ?? "",
                                            phone: phoneTF.text?.trim ?? "")
                    viewModel.createCustomer(customer: customer)
                    self.view.endEditing(true)
                    
                    
                }
    }
}


extension RegisterVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.firstNameTF:          self.lastNameTF.becomeFirstResponder()
        case self.lastNameTF:           self.emailTF.becomeFirstResponder()
        case self.emailTF:              self.passwordTF.becomeFirstResponder()
        case self.passwordTF:           self.confirmPasswordTF.becomeFirstResponder()
        case self.confirmPasswordTF:    self.phoneTF.becomeFirstResponder()
        case self.phoneTF:              self.phoneTF.resignFirstResponder()
        default:
            self.resignFirstResponder()
        }
    }
}
