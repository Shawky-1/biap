//
//  Information.swift
//  Biap
//
//  Created by Bassant on 10/03/2023.
//

import UIKit

class Information: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    
    var info:String = ""
    
    func info (infoTextView: String!) {
        
        self.infoTextView?.text = infoTextView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTextView?.text = info
        //infoTextView.text = ""
        // Do any additional setup after loading the view.
    }




}
