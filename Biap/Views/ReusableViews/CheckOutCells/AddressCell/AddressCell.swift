//
//  AddressCell.swift
//  Biap
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var fullName: TextField!
    @IBOutlet weak var address: TextField!
    @IBOutlet weak var province: TextField!
    @IBOutlet weak var city: TextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
