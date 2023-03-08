//
//  CartViewController.swift
//  Biap
//
//  Created by Abdelrahman on 06/03/2023.
//

import UIKit
import RealmSwift
import Realm

class CartViewController: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    
    @IBOutlet weak var checkOut: UIButton!
    

    var cartArray:[Cart] = []
    let realm = try! Realm()
    var sum:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDatafromRealm()
        tableView.reloadData()
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
        
    }

    func setupUI(){
        self.navigationController?.navigationBar.tintColor = UIColor.label
        checkOut.cornerRadius = checkOut.bounds.height / 2
        tableView.registerCellNib(cellClass: ShoppingCartCell.self)
    }
    
    
    @IBAction func checkOutAction(_ sender: Any) {
        if (UserDefaults.standard.string(forKey: "email") != nil){
            let vc = PaymentOptions(nibName: "PaymentOptions", bundle: nil)
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
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as! ShoppingCartCell
        
        cell.productName.text = cartArray[indexPath.row].name
        cell.productSize.text = cartArray[indexPath.row].size
        cell.productColor.text = cartArray[indexPath.row].color
        cell.productPrice.text = String(format: "%.2f", cartArray[indexPath.row].price * ((cell.productQuantity.text)! as NSString).doubleValue)
        cell.originalPrice = cell.productPrice.text!
        
        
        cell.bindPricesToTableView = {[weak self] totalPrice in
            let sum1 = self!.sum
            self?.sum = sum1 + totalPrice
            self?.subTotal.text = String(format: "%.2f", sum1 + totalPrice)
        }
    
        let productImageUrl = URL(string: cartArray[indexPath.row].image ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        
        return cell
    }
    
   
    
    
}

extension CartViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/3.3
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert:UIAlertController = UIAlertController(title: "Delete!", message: "Do you really want to delete this Product?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
           
            let products = try! Realm().objects(Cart.self)
            try! self.realm.write({
                self.realm.delete(products[indexPath.row])
            })
            self.cartArray.removeAll()
            for each in products{
                self.cartArray.append(each)
            }
            self.sum = 0.0
            for each in self.cartArray{
                self.sum += each.price
            }
            self.subTotal.text = String(format: "%.2f", self.sum)
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default,handler: nil))
        
        self.present(alert,animated: true,completion: nil)
        
        
    }
}

