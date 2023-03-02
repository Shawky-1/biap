//
//  File.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation

enum URLS {
    static let baseURL: String = "https://\(EndPoints.apiKey):\(EndPoints.apiPassword)@\(EndPoints.storeName).myshopify.com/admin/api/\(EndPoints.apiVersion)"
    
    enum customer: String {
        case newCustomer = "/customers"
    }
    
    enum products: String{
        case brands = "/smart_collections.json"
    }
}

struct EndPoints{
    static let apiKey: String = "80300e359dad594ca2466b7c53e94435"
    static let apiPassword: String = "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"
    static let storeName: String = "mad-ism202"
    static let apiVersion: String = "2023-01"
}
