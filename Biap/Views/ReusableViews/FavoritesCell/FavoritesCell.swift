//
//  FavoritesCell.swift
//  Biap
//
//  Created by Abdelrahman on 07/03/2023.
//

import UIKit

class FavoritesCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    var bindDeleteToFavoritesView:(() -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteFromFavorites(_ sender: Any) {
        bindDeleteToFavoritesView!()
    }
    
}
