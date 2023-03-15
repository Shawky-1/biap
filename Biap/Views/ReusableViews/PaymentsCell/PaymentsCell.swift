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
    
}
