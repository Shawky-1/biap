//
//  PaymentOptions.swift
//  Biap
//
//  Created by Bassant on 06/03/2023.
//

import UIKit

class PaymentOptions: UIViewController {

    @IBOutlet weak var paymentOptionsTable: UITableView!
    
//    var selectedOption = "Cash On Delivery"
    var cart: [Cart]!
    var discountAmmount = 0.0
    struct paymentOption{
        let paymentType: String
        let options:[String]
    }
    
    var Payments = [paymentOption(paymentType: "Online payment", options: ["Pay with card"]),
                    paymentOption(paymentType: "More payment options", options: ["Cash On Delivery"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment options"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        paymentOptionsTable.delegate = self
        paymentOptionsTable.dataSource = self
        
        paymentOptionsTable.register(UINib(nibName: "PaymentsCell", bundle: nil), forCellReuseIdentifier: "PaymentsCell")
    }

    @IBAction func continueToPayment(_ sender: Any) {
        
//        let VC = CheckOut(nibName: "CheckOut", bundle: nil)
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

extension PaymentOptions: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Payments[section].options.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        Payments.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Payments[section].paymentType
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = paymentOptionsTable.dequeueReusableCell(withIdentifier: "PaymentsCell", for: indexPath) as! PaymentsCell
        let option = Payments[indexPath.section].options[indexPath.row]
        cell.paymentOptionLabel.text = option
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = paymentOptionsTable.cellForRow(at: indexPath) as! PaymentsCell
//        selectedOption = Payments[indexPath.section].options[indexPath.row]
        let checkOutVM = CheckOutVM()
        checkOutVM.cart = self.cart
        checkOutVM.discountAmmount = self.discountAmmount
        let checkOutVC = CheckOutVC()
        checkOutVC.viewModel = checkOutVM
        if indexPath.section == 0{
            checkOutVC.payWithCard = true
            self.navigationController?.pushViewController(checkOutVC, animated: true)
        } else if indexPath.section == 1 {
            checkOutVC.payWithCard = false
            self.navigationController?.pushViewController(checkOutVC, animated: true)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
}
