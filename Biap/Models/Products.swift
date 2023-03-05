//
//  Products.swift
//  Biap
//
//  Created by Abdelrahman on 02/03/2023.
//

import Foundation
struct products:Codable{
    var products:[properies]
}


struct singleProduct:Codable{
    let product:properies
}

struct properies:Codable{
    let id:Int?
    let title:String?
    let body_html:String?
    let vendor:String?
    let product_type:String?
    let variants:[Vproperties]?
    let options:[option]
    let images:[images]
}



struct Vproperties:Codable{
    let id:Int?
    let title:String?
    let price:String?
    let option1:String?
    let option2:String?
    let option3:String?
    let inventory_quantity:Int?
}


struct images:Codable{
    let id:Int
    let position:Int
    let src:String
}


struct option:Codable{
    let product_id:Int?
    let name:String?
    let values:[String]?
}

