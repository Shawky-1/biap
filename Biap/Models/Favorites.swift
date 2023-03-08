//
//  Favorites.swift
//  Biap
//
//  Created by Abdelrahman on 07/03/2023.
//

import Foundation
import RealmSwift

class Favorite:Object{
    @objc dynamic var name:String?
    @objc dynamic var size:String?
    @objc dynamic var color:String?
    @objc dynamic var image:String?
    @objc dynamic var variantId:Int = 0
    @objc dynamic var productId:Int = 0
    @objc dynamic var price:Double = 0.0
    
    /*init(name: String? = nil, size: String? = nil, color: String? = nil, image: String? = nil, variantId: Int, productId: Int, price: Double) {
        self.name = name
        self.size = size
        self.color = color
        self.image = image
        self.variantId = variantId
        self.productId = productId
        self.price = price
    }*/
}