//
//  CartViewController.swift
//  Biap
//
//  Created by Abdelrahman on 06/03/2023.
//

import UIKit
import RealmSwift
import Realm
import Reachability
class CartViewController: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var checkOut: UIButton!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var subTotalText: UILabel!
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var couponTF: TextField!
    @IBOutlet weak var Currency: UILabel!
    var currency = ""
    var cartArray:[Cart] = []
    let realm = try! Realm()
    var sum:Double = 0.0
    var sumAfterDiscount:Double = 0.0
    var discountAmmount:Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currency = UserDefaults.standard.string(forKey: "currency") ?? ""
        setupUI()
        
        loadDatafromRealm()
        tableView.reloadData()
        checkConnection()

    }
    
    func loadDatafromRealm(){
        let products = try! Realm().objects(Cart.self)
        cartArray.removeAll()
        for each in products{
            cartArray.append(each)
        }
        sum = 0.0
        for each in cartArray{
            sum += each.price * Double(each.quantity)
        }
        subTotal.text = String(format: "%.2f", sum)
        if cartArray.isEmpty{
            tableView.isHidden = true
            emptyImage.isHidden = false
            checkOut.isHidden = true
            subTotal.isHidden = true
            subTotalText.isHidden = true
            Currency.isHidden = true
            self.checkoutView.isHidden = true
        }
        applyCoupon()
    }
    
    func checkConnection(){
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.tableView.isHidden = true
            self.imagePlaceHolder.isHidden = false
            checkOut.isHidden = true
            subTotal.isHidden = true
            subTotalText.isHidden = true
            checkoutView.isHidden = true
            emptyImage.isHidden = true
            Currency.isHidden = true
        }
    }

    func setupUI(){
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        checkOut.cornerRadius = checkOut.bounds.height / 2
        tableView.registerCellNib(cellClass: ShoppingCartCell.self)
        self.title = "Shopping Cart"
        if currency == "USD" || currency == ""{
            self.Currency.text = "USD"
        }else{
            self.Currency.text = currency
        }
        //
        tableView.allowsSelection = false
    }
    
    private func applyCoupon(){
        sumAfterDiscount = sum
        if discountAmmount != 0.0{
            let discount = sum * (discountAmmount / 100)
            sumAfterDiscount = sum - discount
            subTotal.text = String(sumAfterDiscount)
            self.discountLbl.text = "\(discountAmmount)%"
        }
    }
    
    @IBAction func validateCouponClicked(_ sender: Any) {
        guard let discountCode = couponTF.text else {
            self.showToast(message: "Coupon invalid", font: .systemFont(ofSize: 12))
            return
        }
        for coupon in globalCoupons.shared.coupones{
            if coupon.code == discountCode{
                self.showToast(message: "Valid coupon!", font: .systemFont(ofSize: 12))
                self.discountAmmount = coupon.discountAmmount ?? 0.0
                applyCoupon()
                return
            }
        }
        self.showToast(message: "Coupon invalid", font: .systemFont(ofSize: 12))
    }
    
    @IBAction func checkOutAction(_ sender: Any) {
        if (UserDefaults.standard.string(forKey: "email") != nil){
            let vc = PaymentOptions(nibName: "PaymentOptions", bundle: nil)
            vc.cart = self.cartArray
            vc.discountAmmount = discountAmmount
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.presentAlertViewWithOneButtonMIV(alertTitle: "Invalid login.", alertMessage: "You need to be logged-in to proceed to checkout.", btnOneTitle: "Login") { action in
                
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)

            }
        }
    }
    



}

extension CartViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as! ShoppingCartCell
        cell.item = cartArray[indexPath.section]
        cell.productName.text = cartArray[indexPath.section].name
        cell.productSize.text = cartArray[indexPath.section].size
        cell.productColor.text = cartArray[indexPath.section].color
        if currency == "USD" || currency == ""{
            cell.Currency.text = "USD"
        }else{
            cell.Currency.text = currency
        }
        cell.stepper.value = Double(cartArray[indexPath.section].quantity)
        cell.oldValue = cell.stepper.value
        cell.productQuantity.text = String(format: "%.0f",cell.stepper.value)
        cell.productPrice.text = String(format: "%.2f", cartArray[indexPath.section].price * Double(cartArray[indexPath.section].quantity))
        cell.originalPrice = String(cartArray[indexPath.section].price)//cell.productPrice.text!

        
        let productImageUrl = URL(string: cartArray[indexPath.section].image ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
            
        
        //steper value = 0 delete the object
        cell.bindDeleteToTableView = {[weak self] in
            guard let self = self else {return}
            
            let alert:UIAlertController = UIAlertController(title: "Delete!", message: "Do you really want to remove this Product from your Shopping Cart ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
               
                let products = try! Realm().objects(Cart.self)
                try! self.realm.write({
                    self.realm.delete(products[indexPath.section])
                })
                self.cartArray.removeAll()
                for each in products{
                    self.cartArray.append(each)
                }
                self.sum = 0.0
                for each in self.cartArray{
                    self.sum += each.price * Double(each.quantity)
                }
                self.subTotal.text = String(format: "%.2f", self.sum)
                if self.cartArray.isEmpty{
                    self.tableView.isHidden = true
                    self.emptyImage.isHidden = false
                    self.checkOut.isHidden = true
                    self.subTotal.isHidden = true
                    self.subTotalText.isHidden = true
                    self.Currency.isHidden = true
                    self.checkoutView.isHidden = true
                }
                self.applyCoupon()
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default,handler: { action in
                cell.stepper.value = 1
                cell.productQuantity.text =  String(format: "%.0f", cell.stepper.value)
                cell.productPrice.text = String(format: "%.2f", self.cartArray[indexPath.section].price * ((cell.productQuantity.text)! as NSString).doubleValue)
            }))
            
            self.present(alert,animated: true,completion: nil)
        }
        
        //bind Prices
        cell.bindPricesToTableView = {[weak self] totalPrice in
            guard let self = self else {return}
            if let product = try! Realm().objects(Cart.self).filter("variantId == %@", cell.item.variantId).first{
                try! self.realm.write({
                    product.quantity = Int(cell.stepper.value)
                })
            }
            //var sum1 = 0.0
            let sum1 = self.sum
            self.sum = sum1 + totalPrice
            self.subTotal.text = String(format: "%.2f", sum1 + totalPrice)
            self.applyCoupon()
        }
    
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension CartViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
        let alert:UIAlertController = UIAlertController(title: "Delete!", message: "Do you really want to remove this Product from your Shopping Cart ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
           
            let products = try! Realm().objects(Cart.self)
            try! self.realm.write({
                self.realm.delete(products[indexPath.section])
            })
            self.cartArray.removeAll()
            for each in products{
                self.cartArray.append(each)
            }
            
            self.sum = 0.0
            for each in self.cartArray{
                self.sum += each.price * Double(each.quantity)
            }
            self.subTotal.text = String(format: "%.2f", self.sum)
            if self.cartArray.isEmpty{
                self.tableView.isHidden = true
                self.emptyImage.isHidden = false
                self.checkOut.isHidden = true
                self.subTotal.isHidden = true
                self.subTotalText.isHidden = true
                self.Currency.isHidden = true
                self.checkoutView.isHidden = true

            }
            self.applyCoupon()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default,handler: { action in
        }))
        
        self.present(alert,animated: true,completion: nil)
        
        
        
    }
    

}

