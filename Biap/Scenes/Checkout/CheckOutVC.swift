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
    
    var payWithCard:Bool = false
//    var customer:Customer
//    var order:String // OF type order in future



}

extension CheckOutVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            return cell
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
        case 1:
            return "Shipping details"
        case 2:
            return "Billing Details"
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
        case 1:
            return self.view.bounds.height / 3.5
        default:
            return self.view.bounds.height / 3.5

        }
    }
    
}

