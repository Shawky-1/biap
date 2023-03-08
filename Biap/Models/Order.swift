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
