//
//  CheckOutVC.swift
//  Biap
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import UIKit

class CheckOutVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
            tableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        }
    }
    
    var viewModel: CheckOutVM!
    @IBOutlet weak var titleLbl: UILabel!
    var payWithCard:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Checkout"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.titleLbl.text = "Total ammount: \(viewModel.totalAmmount())"
        viewModel.orderSucessful = {bool in
            if bool {
                self.presentAlertViewWithOneButtonMIV(alertTitle: "Order", alertMessage: "Order Created sucessfully!", btnOneTitle: "Ok") { action in
                    RealmManager.deleteCart()
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
            } else {
                self.presentAlertViewWithOneButtonMIV(alertTitle: "Order", alertMessage: "Error creating the order.", btnOneTitle: "Ok") { action in
                    
                }
            }
        }
    }
    
    
    @IBAction func didClickCheckout(_ sender: Any) {
        viewModel.createOrder()
    }
    
}

extension CheckOutVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            if payWithCard{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
                return cell
                
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            if payWithCard{
                return "Card details"
            } else {
                return ""
            }
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            if payWithCard{
                return self.view.bounds.height / 3.5
            } else {
                return 0
            }
        default:
            return self.view.bounds.height / 3.5

        }
    }
    
}

