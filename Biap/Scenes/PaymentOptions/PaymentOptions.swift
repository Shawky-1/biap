//
//  PaymentOptions.swift
//  Biap
//
//  Created by Bassant on 06/03/2023.
//

import UIKit
import PassKit

class PaymentOptions: UIViewController {

    @IBOutlet weak var paymentOptionsTable: UITableView!
    
//    var selectedOption = "Cash On Delivery"
    var cart: [Cart]!
    var discountAmmount:Double = 0.0
    let currency = UserDefaults.standard.string(forKey: "currency") ?? ""
    var checkoutVM = CheckOutVM()
    struct paymentOption{
        let paymentType: String
        let options:[String]
    }
    private let paymentRequest: PKPaymentRequest = {
       let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.Test"
        request.supportedNetworks = [.masterCard, .visa]
        request.supportedCountries = ["EG"]
        request.merchantCapabilities = .capability3DS
        
        request.countryCode = "EG"
        
        return request
    }()
    
    var Payments = [paymentOption(paymentType: "Online payment", options: ["Pay with card", "Pay with apple pay"]),
                    paymentOption(paymentType: "More payment options", options: ["Cash On Delivery"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutVM.cart = cart
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
//        let cell = paymentOptionsTable.cellForRow(at: indexPath) as! PaymentsCell
//        selectedOption = Payments[indexPath.section].options[indexPath.row]
        let checkOutVM = CheckOutVM()
        checkOutVM.cart = self.cart
        checkOutVM.discountAmmount = self.discountAmmount
        let checkOutVC = CheckOutVC()
        checkOutVC.viewModel = checkOutVM
        
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                checkOutVC.payWithCard = true
                self.navigationController?.pushViewController(checkOutVC, animated: true)
            case 1:
                configApplePay()
            default:
                break
            }
        } else if indexPath.section == 1 {
            checkOutVC.payWithCard = false
            self.navigationController?.pushViewController(checkOutVC, animated: true)
            
        }
    }
    
    private func configApplePay(){
        if currency == "USD" || currency == ""{
            paymentRequest.currencyCode = "USD"
        }else{
            paymentRequest.currencyCode = "EGP"
        }
        let subtotal:Double = {
            var total:Double = 0
            self.cart.forEach { cart in
                for _ in 1...cart.quantity{
                    total += cart.price
                }
            }
            return total
        }()
        let discountPrice = subtotal * discountAmmount / 100
        let taxesPrice = subtotal * 0.14
        let totalAmmount = (subtotal - discountPrice) + taxesPrice
        
//        var summeryItems:[PKPaymentSummaryItem] = []
//        for item in cart{
//            for _ in 1...item.quantity{
//                summeryItems.append(PKPaymentSummaryItem(label: item.name ?? "", amount: NSDecimalNumber(value: item.price)))
//            }
//        }
        
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "taxes (14%)", amount: NSDecimalNumber(value: taxesPrice.rounded())),
                                              PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(value: -discountPrice.rounded())),
                                              PKPaymentSummaryItem(label: "Subtotal", amount: NSDecimalNumber(value: subtotal.rounded())),
                                              PKPaymentSummaryItem(label: "Biap cart", amount: NSDecimalNumber(value: totalAmmount.rounded()))]

        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil{
            controller!.delegate = self
            present(controller!, animated: true){
                
            }
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
}

extension PaymentOptions: PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
//        self.paymentRequest.paymentSummaryItems = []
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        checkoutVM.createOrder()
        checkoutVM.orderSucessful = {sucess in
            if sucess {
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                RealmManager.deleteCart()
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            }
        }
//        self.paymentRequest.paymentSummaryItems = []
    }
}
