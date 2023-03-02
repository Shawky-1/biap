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
    
    
    @IBOutlet weak var productPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


