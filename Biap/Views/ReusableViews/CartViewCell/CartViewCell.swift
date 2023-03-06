//
//  CartViewCell.swift
//  Biap
//
//  Created by Abdelrahman on 06/03/2023.
//

import UIKit
import RealmSwift

class CartViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var cartArray:[Cart] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        renderData()
        stepper.autorepeat = true
        stepper.isContinuous = true
        stepper.maximumValue = 20
        stepper.minimumValue = 0
        stepper.value = 1
        productQuantity.text = String(format: "%0.f", stepper.value)
        
        
        
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        productQuantity.text =  String(format: "%.0f", stepper.value)
        
    }
    
    
    func renderData(){
        let products = try! Realm().objects(Cart.self)
        /*try! realm.write({
            realm.deleteAll()
        })*/
        for each in products{
            cartArray.append(each)
        }
    }
    

}
