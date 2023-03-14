//
//  MeViewController.swift
//  Biap
//
//  Created by Abdelrahman on 08/03/2023.
//

import UIKit
import Reachability
import RealmSwift

class MeViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var EmptyPlaceholder: UIImageView!
    
    var currency:String = ""
    
    var viewModel:MeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = MeViewModel()
        currency = UserDefaults.standard.string(forKey: "currency") ?? ""
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        viewModel.getOrders(url: urls.ordersUrl(id: id))
        viewModel.bindResultToMeView = {[weak self] in
            guard let self = self else {return}
            if self.viewModel.listOfOrders.orders.isEmpty{
                self.ordersTableView.isHidden = true
                self.EmptyPlaceholder.isHidden = false
            }
            self.ordersTableView.reloadData()
        }
        checkConnection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartIndicator()
    }
    
    @objc func settingButton(sender:UIBarButtonItem){
        if (UserDefaults.standard.string(forKey: "email") == nil){
            let loginVC = LoginVC()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            
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
    
    func checkConnection(){
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.ordersTableView.isHidden = true
            self.imagePlaceHolder.isHidden = false
      
        }
    }
    
    
    
    func setupUI(){
        
        
        ordersTableView.allowsSelection = false
        self.title = "Account"
        
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
    
    func cartIndicator(){
       let products = try! Realm().objects(Cart.self)
        
        
        //setting button
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape") , style: .plain, target: self, action: #selector(settingButton))
        settingButton.tintColor = .label
        
        let cartButtonn = SSBadgeButton()
        cartButtonn.frame = CGRect(x: 22, y: -05, width: 20, height: 20)
        //cartIcon.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            cartButtonn.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cartButtonn.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            cartButtonn.addTarget(self, action: #selector(cartButton), for: .touchUpInside)
        cartButtonn.badge = String(products.count)
        cartButtonn.tintColor = .label
        
        if products.isEmpty{
            cartButtonn.isHidden = true
        }
    
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightBarButton.addTarget(self, action: #selector(self.cartButton), for: .touchUpInside)
        rightBarButton.setImage(UIImage(systemName: "cart"), for: .normal)
        rightBarButton.tintColor = .label
        rightBarButton.addSubview(cartButtonn)
        
        navigationItem.rightBarButtonItems = [settingButton,UIBarButtonItem.init(
            customView: rightBarButton)]
        
    }
    
    
    
    @IBAction func registerAction(_ sender: Any) {
        let loginVC = LoginVC()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
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
        if currency == "USD" || currency == ""{
            cell.subTotalLabel.text = "USD"
            cell.discountLabel.text = "USD"
            cell.totalLabel.text = "USD"
        }else{
            cell.subTotalLabel.text = currency
            cell.discountLabel.text = currency
            cell.totalLabel.text = currency
        }
        
        if currency == "USD" || currency == ""{
            cell.totalPrice.text = viewModel.listOfOrders?.orders[indexPath.row].current_subtotal_price
            cell.discount.text = viewModel.listOfOrders?.orders[indexPath.row].current_total_discounts
            cell.priceAfterDiscount.text = viewModel.listOfOrders?.orders[indexPath.row].current_total_price
        }else{
            let subTotalPrice = viewModel.listOfOrders?.orders[indexPath.row].current_subtotal_price ?? ""
            let egp_subTotalPrice =  (((subTotalPrice) as NSString).doubleValue) * 30
            cell.totalPrice.text = String(egp_subTotalPrice)
            
            let discount =  viewModel.listOfOrders?.orders[indexPath.row].current_total_discounts ?? ""
            let egp_discount =  (((discount) as NSString).doubleValue) * 30
            cell.discount.text = String(egp_discount)
            
            let priceAfterDiscount =  viewModel.listOfOrders?.orders[indexPath.row].current_total_price ?? ""
            let egp_priceAfterDiscount =  (((priceAfterDiscount ) as NSString).doubleValue) * 30
            cell.priceAfterDiscount.text = String(egp_priceAfterDiscount)
            
        }
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
