//
//  Order.swift
//  Biap
//
//  Created by Ahmed Shawky on 08/03/2023.
//

import Foundation
import UIKit

struct Order: Codable {
    let lineItems: [LineItem]
    let customer: Customer
    let billingAddress: Address
    let shippingAddress: Address

    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customer
        case billingAddress = "billing_address"
        case shippingAddress = "shipping_address"
    }
}

struct LineItem: Codable {
    let variantID: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case variantID = "variant_id"
        case quantity
    }
}

struct orders:Codable{
    let orders:[orderProperies]
}

struct orderProperies:Codable{
    let id:Int?
    let created_at:String?
    let current_subtotal_price:String?
    let current_total_discounts:String?
    let current_total_price:String?
}



struct OrderResponse: Decodable {
    let id: Int
    let confirmed: Bool
    let contactEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case order
    }
    
    enum OrderCodingKeys: String, CodingKey {
        case id
        case confirmed
        case contactEmail = "contact_email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let orderValues = try values.nestedContainer(keyedBy: OrderCodingKeys.self, forKey: .order)
        id = try orderValues.decode(Int.self, forKey: .id)
        confirmed = try orderValues.decode(Bool.self, forKey: .confirmed)
        contactEmail = try orderValues.decodeIfPresent(String.self, forKey: .contactEmail)
    }
}
