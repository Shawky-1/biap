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
    
    var cartArray:[Cart] = []
    let realm = try! Realm()
    var sum:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        for each in cartArray{
            sum += each.price
        }
        subTotal.text = String(format: "%.2f", sum)
        if cartArray.isEmpty{
            tableView.isHidden = true
            emptyImage.isHidden = false
            checkOut.isHidden = true
            subTotal.isHidden = true
            subTotalText.isHidden = true
        }
    }
    
    func checkConnection(){
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.tableView.isHidden = true
            self.imagePlaceHolder.isHidden = false
            checkOut.isHidden = true
            subTotal.isHidden = true
            subTotalText.isHidden = true
            emptyImage.isHidden = true
        }
    }

    func setupUI(){
        self.navigationController?.navigationBar.tintColor = UIColor.label
        checkOut.cornerRadius = checkOut.bounds.height / 2
        tableView.registerCellNib(cellClass: ShoppingCartCell.self)
        self.title = "Shopping Cart"
        tableView.allowsSelection = false
    }
    
    
    @IBAction func checkOutAction(_ sender: Any) {
        if (UserDefaults.standard.string(forKey: "email") != nil){
            let vc = PaymentOptions(nibName: "PaymentOptions", bundle: nil)
            vc.cart = self.cartArray
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.presentAlertViewWithOneButtonMIV(alertTitle: "Invalid login.", alertMessage: "You need to be logged in in order to proceed to checkout.", btnOneTitle: "Login") { action in
                
                let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                
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
        cell.productPrice.text = String(format: "%.2f", cartArray[indexPath.section].price * ((cell.productQuantity.text)! as NSString).doubleValue)
        cell.originalPrice = cell.productPrice.text!
//        cell.productQuantity.text = String(cartArray[indexPath.row].quantity)
//        cell.stepper.value = Double(cartArray[indexPath.row].quantity)
        
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
                cell.stepper.value = 1
                cell.productQuantity.text =  String(format: "%.0f", cell.stepper.value)
                self.sum = 0.0
                for each in self.cartArray{
                    self.sum += each.price
                }
                self.subTotal.text = String(format: "%.2f", self.sum)
                if self.cartArray.isEmpty{
                    self.tableView.isHidden = true
                    self.emptyImage.isHidden = false
                    self.checkOut.isHidden = true
                    self.subTotal.isHidden = true
                    self.subTotalText.isHidden = true}
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

            let sum1 = self.sum
            self.sum = sum1 + totalPrice
            self.subTotal.text = String(format: "%.2f", sum1 + totalPrice)
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

}

