//
//  WalkthroughCell.swift
//  Biap
//
//  Created by Bassant on 11/03/2023.
//

import UIKit

class WalkthroughCell: UICollectionViewCell {
    
    @IBOutlet weak var walktroughImage: UIImageView!
    @IBOutlet weak var walkthoughTitle: UILabel!
    @IBOutlet weak var walkthroughDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(slide: WalkthroughSlide){
        walktroughImage.image = slide.image
        walkthoughTitle.text = slide.title
        walkthroughDescription.text = slide.description
    }
}

struct WalkthroughSlide{
    let title: String
    let description: String
    let image: UIImage
}
