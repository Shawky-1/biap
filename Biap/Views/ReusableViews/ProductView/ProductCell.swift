//
//  ProductCell.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var inStockLbl: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var Currency: UILabel!
    
    var bindAddActionToTableView:(() -> ())?
    var bindDeleteActionToTableView:(() -> ())?
    var exist = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

    @IBAction func favoriteAction(_ sender: Any) {
        if exist{
            (sender as AnyObject).setImage(UIImage(systemName: "heart"), for: .normal)
           bindDeleteActionToTableView!()
       }else{
           (sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
           bindAddActionToTableView!()
           
       }
        exist = !exist
        
    }
}




