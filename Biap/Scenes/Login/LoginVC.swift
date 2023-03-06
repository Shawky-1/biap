//
//  LoginVC.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    var viewModel: LoginVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginVM()
        viewModel.viewDidLoad()
        setupUI()
        
        viewModel.didLogin = {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                print(message)
                self.viewModel.storeCustomer()
                self.navigateToHomeVC()
            case .failure(let error as LoginError):
                print(error.localizedDescription)
                self.errorLbl.text = error.localizedDescription
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func setupUI(){
        self.title = "Login"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        loginBtn.cornerRadius = loginBtn.bounds.height / 2
        registerBtn.cornerRadius = loginBtn.bounds.height / 2
    }
    
    func navigateToHomeVC(){
        let viewController = CustomTabbarVC(nibName: "CustomTabbarVC", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didClickContinue(_ sender: Any) {
        navigateToHomeVC()
    }
    @IBAction func didPressLogin(_ sender: Any) {
        viewModel.login(email: emailTF.text ?? "", password: passwordTF.text ?? "")
    }
    
    @IBAction func didClickRegister(_ sender: Any) {
        let viewController = RegisterVC(nibName: "RegisterVC", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
//        self.present(viewController, animated: true, completion: nil)
    }
    
}
