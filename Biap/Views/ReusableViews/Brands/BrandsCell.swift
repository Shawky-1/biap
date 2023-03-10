//
//  BrandsCell.swift
//  Biap
//
//  Created by Ahmed Shawky on 02/03/2023.
//

import UIKit

class BrandsCell: UICollectionViewCell {

    @IBOutlet weak var brandImageV: UIImageView!
    
    @IBOutlet weak var brandName: UILabel!
    
    var didClickFav: ((Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //func configureCell(brand: Brand.SmartCollections){
    //}


}
