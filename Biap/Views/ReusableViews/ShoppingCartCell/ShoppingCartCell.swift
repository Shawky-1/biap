//
//  ShoppingCartCell.swift
//  Biap
//
//  Created by Abdelrahman on 06/03/2023.
//

import UIKit
import RealmSwift

class ShoppingCartCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    let realm = try! Realm()
    var bindPricesToTableView:((Double) -> ())?
    var bindDeleteToTableView:(() -> ())?
    var oldValue:Double = 0.0
    var item: Cart!
    
    
    var originalPrice:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.autorepeat = true
        stepper.isContinuous = true
        stepper.maximumValue = 100
        stepper.minimumValue = 0
        stepper.value = 1
        oldValue = stepper.value
        print(oldValue)
        
        productQuantity.text = String(format: "%0.f", stepper.value)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func stepperAction(_ sender: Any) {
        
        productQuantity.text =  String(format: "%.0f", stepper.value)

        productPrice.text = String(format: "%.2f", ((originalPrice) as NSString).doubleValue * ((productQuantity.text)! as NSString).doubleValue)
        let doubleProductPrice = ((productPrice.text)! as NSString).doubleValue
        let doubleOriginalPrice = ((originalPrice) as NSString).doubleValue
        
        if stepper.value > oldValue{
            oldValue = oldValue + 1
            bindPricesToTableView!(doubleProductPrice - (doubleOriginalPrice * (stepper.value - 1 )))
            
        }else{
            if stepper.value == 0{
                bindDeleteToTableView!()
            }else{
                oldValue = oldValue - 1
                bindPricesToTableView!(doubleProductPrice - (doubleOriginalPrice * (stepper.value + 1 )))
            }
            
        }
        
    }
    
}
