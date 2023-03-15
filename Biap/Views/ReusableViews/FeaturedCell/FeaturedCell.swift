//
//  FeaturedCell.swift
//  Biap
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import UIKit
import Kingfisher

class FeaturedCell: UICollectionViewCell {

    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var productTitleLbl: UILabel!
    
    @IBOutlet weak var productVendorLbl: UILabel!
    
    @IBOutlet weak var productPriceLbl: UILabel!
    
    @IBOutlet weak var ratingView: RatingView!
    var israted: Bool = false
    var currency: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: properies, price:String){
        var priceAttributed: String = "\(price) \(currency)"
        productTitleLbl.text = product.title
        productVendorLbl.text = product.vendor
        productPriceLbl.text = priceAttributed
        
        let imgURL = URL(string:product.images[0].src)
        
        let processor = DownsamplingImageProcessor(size: productImg.bounds.size)
        productImg.kf.indicatorType = .activity

        productImg.kf.setImage(
            with: imgURL,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }

}
