//
//  ProductCell.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var productPrice: UILabel!
    var exist = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    @IBAction func favoriteAction(_ sender: Any) {
        if exist{
            (sender as AnyObject).setImage(UIImage(systemName: "heart"), for: .normal)
           
       }else{
           (sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
           
       }
        exist = !exist
        
    }
}




