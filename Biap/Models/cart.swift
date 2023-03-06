//
//  cart.swift
//  Biap
//
//  Created by Abdelrahman on 06/03/2023.
//

import Foundation
import RealmSwift

class Cart:Object{
    @objc dynamic var name:String?
    @objc dynamic var size:String?
    @objc dynamic var color:String?
    @objc dynamic var image:String?
    @objc dynamic var price:Double = 0.0
    
    /*init(name: String? = nil, size: String? = nil, color: String? = nil, image: String? = nil, price: Double = 0.0) {
        self.name = name
        self.size = size
        self.color = color
        self.image = image
        self.price = price
    }*/
}
