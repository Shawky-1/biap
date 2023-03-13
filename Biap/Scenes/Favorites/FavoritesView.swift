//
//  FavoritesView.swift
//  Biap
//
//  Created by Abdelrahman on 07/03/2023.
//

import UIKit
import RealmSwift
import Realm
import Reachability

class FavoritesView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    
    var favArray:[Favorite] = []
    let realm = try! Realm()
    let currency = UserDefaults.standard.string(forKey: "currency") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDatafromRealm()
        tableView.reloadData()
        checkConnection()
    }
    
    func loadDatafromRealm(){
        let products = try! Realm().objects(Favorite.self)
        favArray.removeAll()
        for each in products{
            favArray.append(each)
        }
        if favArray.isEmpty{
            tableView.isHidden = true
            emptyImage.isHidden = false
        }else{
            tableView.isHidden = false
            emptyImage.isHidden = true
        }
    }
    
    
    func checkConnection(){
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.tableView.isHidden = true
            self.imagePlaceHolder.isHidden = false
            emptyImage.isHidden = true
        }
    }

    func setupUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",image: UIImage(systemName: "cart"), target: self,action: #selector(cartButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        tableView.registerCellNib(cellClass: FavoritesCell.self)
        self.title = "Favorites"
        tableView.allowsSelection = false
    }
    
    //bar button
    @objc func cartButton(sender:UIBarButtonItem){
        let vc = CartViewController(nibName: "CartViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension FavoritesView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        favArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        
        cell.productName.text = favArray[indexPath.section].name
        cell.productPrice.text = String(format: "%.2f", favArray[indexPath.section].price)
        if currency == ""{
            cell.Currency.text = "USD"
        }else{
            cell.Currency.text = favArray[indexPath.section].currency
        }
        let productImageUrl = URL(string: favArray[indexPath.section].image ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        
        
        cell.bindDeleteToFavoritesView = {[weak self] in
            guard let self = self else {return}
            
            let alert:UIAlertController = UIAlertController(title: "Delete!", message: "Do you really want to remove this Product from your Favorites ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
               
                let products = try! Realm().objects(Favorite.self)
                try! self.realm.write({
                    self.realm.delete(products[indexPath.section])
                })
                self.favArray.removeAll()
                for each in products{
                    self.favArray.append(each)
                }
                
                if self.favArray.isEmpty{
                    self.tableView.isHidden = true
                    self.emptyImage.isHidden = false
                   }
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default,handler: nil))
            
            self.present(alert,animated: true,completion: nil)
        }
        
        cell.bindAddToFavoritesView = {[weak self] in
            guard let self = self else {return}
            let vc = ProductDetails(nibName: "ProductDetails", bundle: nil)
            vc.id =  self.favArray[indexPath.section].productId
            vc.price = self.favArray[indexPath.section].price
            vc.variantId = self.favArray[indexPath.section].variantId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
           
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

extension FavoritesView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    

   
}

