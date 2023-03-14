//
//  OrdersCell.swift
//  Biap
//
//  Created by Abdelrahman on 08/03/2023.
//

import UIKit

class OrdersCell: UITableViewCell {
    
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var priceAfterDiscount: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
