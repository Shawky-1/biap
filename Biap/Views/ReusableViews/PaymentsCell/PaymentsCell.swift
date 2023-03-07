//
//  PaymentsCell.swift
//  Biap
//
//  Created by Bassant on 07/03/2023.
//

import UIKit

class PaymentsCell: UITableViewCell {

    @IBOutlet weak var paymentOptionLabel: UILabel!
    
    @IBOutlet weak var paymentOptionImage: UIImageView!
    
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
