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


class urls{
    static func productsViewUrl(vendor:String) -> String{
        let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json?vendor=\(vendor)"
        return url
    }
    
    static func categoriesUrl() -> String{
        let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json"
        return url
    }
    
    static func productsOfCategory(productType:String) -> String{
        let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products.json?product_type=\(productType)"
        return url
    }
    static func productDetailsUrl(id:Int) -> String {
        let url = "https://80300e359dad594ca2466b7c53e94435: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@mad-ism202.myshopify.com/admin/api/2023-01/products/\(id).json"
        
        return url
    }
}
