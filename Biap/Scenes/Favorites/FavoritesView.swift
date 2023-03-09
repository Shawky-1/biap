//
//  FavoritesView.swift
//  Biap
//
//  Created by Abdelrahman on 07/03/2023.
//

import UIKit
import RealmSwift
import Realm

class FavoritesView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    var favArray:[Favorite] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tableView.reloadData()
        loadDatafromRealm()
        tableView.reloadData()
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
        }
    }

    func setupUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",image: UIImage(systemName: "cart"), target: self,action: #selector(cartButton))
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationController?.navigationBar.tintColor = UIColor.label
        tableView.registerCellNib(cellClass: FavoritesCell.self)
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
        return favArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        
        cell.productName.text = favArray[indexPath.row].name
        cell.productPrice.text = String(format: "%.2f", favArray[indexPath.row].price)
        let productImageUrl = URL(string: favArray[indexPath.row].image ?? "")
        cell.productImage.kf.setImage(with: productImageUrl)
        
        
        cell.bindDeleteToFavoritesView = {[weak self] in
            guard let self = self else {return}
            
            let alert:UIAlertController = UIAlertController(title: "Delete!", message: "Do you really want to remove this Product from your Favorites ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
               
                let products = try! Realm().objects(Favorite.self)
                try! self.realm.write({
                    self.realm.delete(products[indexPath.row])
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
        
        return cell
    }
}

extension FavoritesView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/5.5
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert:UIAlertController = UIAlertController(title: "Delete!", message: "Do you really want to delete this Product?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
            let products = try! Realm().objects(Favorite.self)
            try! self.realm.write({
                self.realm.delete(products[indexPath.row])
            })
            self.favArray.removeAll()
            for each in products{
                self.favArray.append(each)
            }
            self.tableView.reloadData()
            if self.favArray.isEmpty{
                self.tableView.isHidden = true
                self.emptyImage.isHidden = false
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default,handler: nil))
        
        self.present(alert,animated: true,completion: nil)
        
        
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetails(nibName: "ProductDetails", bundle: nil)
        vc.id =  favArray[indexPath.row].productId 
        vc.price = favArray[indexPath.row].price
        vc.variantId = favArray[indexPath.row].variantId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

