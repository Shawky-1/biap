//
//  File.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation

enum URLS {
    static let baseURL: String = "https://mad-ism202.myshopify.com/admin/api/2023-01"
    
    enum customer: String {
        case newCustomer = "/customers"
        case searchCustomer = "/customers/search.json"
    }
    
    enum products: String{
        case brands = "/smart_collections.json"
    }
}

struct Tokens{
    //https://mad-ism202.myshopify.com/admin/api/2023-01/customers.json
    static let secretToken: String = "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"
    static let headerToken: String = "X-Shopify-Access-Token"
}
