//
//  SearchCell.swift
//  Biap
//
//  Created by Ahmed Shawky on 09/03/2023.
//

import UIKit
import Kingfisher

class SearchCell: UITableViewCell {

    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(name: String, image: String){
        self.productLbl.text = name
        
        
        let processor = DownsamplingImageProcessor(size: productImage.bounds.size)
        productImage.kf.indicatorType = .activity

        productImage.kf.setImage(
            with: URL(string: image),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])

    }
    
}
