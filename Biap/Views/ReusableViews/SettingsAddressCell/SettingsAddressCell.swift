//
//  SettingsAddressCell.swift
//  Biap
//
//  Created by Bassant on 11/03/2023.
//

import UIKit

class SettingsAddressCell: UITableViewCell {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
