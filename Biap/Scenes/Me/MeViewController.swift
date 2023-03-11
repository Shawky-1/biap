//
//  MeViewController.swift
//  Biap
//
//  Created by Abdelrahman on 08/03/2023.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBOutlet weak var ordersTableView: UITableView!
    var viewModel:MeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = MeViewModel()
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        viewModel.getOrders(url: urls.ordersUrl(id: id/*"6863743451441"*/))
        viewModel.bindResultToMeView = {[weak self] in
            guard let self = self else {return}
            self.ordersTableView.reloadData()
        }
    }
    
    @objc func settingButton(sender:UIBarButtonItem){
        if (UserDefaults.standard.string(forKey: "email") == nil){
            let vc = LoginVC(nibName: "LoginVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        } else {
            //navigate to  setting page
            let vc = SettingsView(nibName: "SettingsView", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cartButton(sender:UIBarButtonItem){
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupUI(){
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape") , style: .plain, target: self, action: #selector(settingButton))
        settingButton.tintColor = .label
        let cartButton = UIBarButtonItem(title: "",image: UIImage(systemName: "cart"), target: self,action: #selector(cartButton))
        cartButton.tintColor = .label
        ordersTableView.allowsSelection = false
        self.title = "Account"
        navigationItem.rightBarButtonItems = [settingButton,cartButton]
        registerButton.cornerRadius = registerButton.bounds.height / 2
        ordersTableView.registerCellNib(cellClass: OrdersCell.self)
        
        if (UserDefaults.standard.string(forKey: "email") == nil){
            userName.text = "Guest!"
            ordersTableView.isHidden = true
            
        } else {
            userName.text = UserDefaults.standard.string(forKey: "firstName")
            registerButton.isHidden = true
            }
        }
    
    
    @IBAction func registerAction(_ sender: Any) {
        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    


}

extension MeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listOfOrders?.orders.count ?? 1
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell", for: indexPath) as! OrdersCell
        
        cell.orderId.text = String(viewModel.listOfOrders?.orders[indexPath.row].id ?? 0)
        cell.orderDate.text = viewModel.listOfOrders?.orders[indexPath.row].created_at
        cell.totalPrice.text = viewModel.listOfOrders?.orders[indexPath.row].current_subtotal_price
        cell.discount.text = viewModel.listOfOrders?.orders[indexPath.row].current_total_discounts
        cell.priceAfterDiscount.text = viewModel.listOfOrders?.orders[indexPath.row].current_total_price
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your Previous Orders"
    }
    
}


extension MeViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
