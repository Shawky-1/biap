//
//  HeaderView.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import UIKit

class HeaderView: UICollectionReusableView {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    
    var didClickViewAll: ((Int)-> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAllBtn.isHidden = true
    }
    
    @IBAction func didClickViewAll(_ sender: Any) {
        didClickViewAll!(5)
    }
}
