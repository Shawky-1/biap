//
//  CardCell.swift
//  Biap
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var nameTF: TextField!
    @IBOutlet weak var cardNumberTF: TextField!
    @IBOutlet weak var expiryDateTF: TextField!
    @IBOutlet weak var cvvTF: TextField!
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
