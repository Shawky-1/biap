//
//  Customer.swift
//  Biap
//
//  Created by Ahmed Shawky on 01/03/2023.
//

import Foundation

struct Customer:Codable {
    let id:Int?
    let email:String
    let firstName:String
    let lastName:String
    let phone:String
    let password:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case password
    }
    
}

struct CustomerResponse:Codable {
    let customers: Customer
//    let id:Int?
//    let email:String
//    let firstName:String
//    let lastName:String
//    let phone:String
//    let password:String
    
}

/*
 {
     "customer": {
         "id": 6851778085169,
         "email": "mohammed@gmail.com",
         "accepts_marketing": false,
         "created_at": "2023-03-01T09:53:42-05:00",
         "updated_at": "2023-03-01T09:53:43-05:00",
         "first_name": "ahmed",
         "last_name": "ali",
         "orders_count": 0,
         "state": "enabled",
         "total_spent": "0.00",
         "last_order_id": null,
         "note": null,
         "verified_email": true,
         "multipass_identifier": null,
         "tax_exempt": false,
         "tags": "",
         "last_order_name": null,
         "currency": "EGP",
         "phone": null,
         "addresses": [
             {
                 "id": 9107861078321,
                 "customer_id": 6851778085169,
                 "first_name": "ahmed",
                 "last_name": "ali",
                 "company": null,
                 "address1": "cairo",
                 "address2": null,
                 "city": "cairo",
                 "province": "Dakahlia",
                 "country": "Egypt",
                 "zip": "3554",
                 "phone": "",
                 "name": "ahmed ali",
                 "province_code": "DK",
                 "country_code": "EG",
                 "country_name": "Egypt",
                 "default": true
             }
         ],
         "accepts_marketing_updated_at": "2023-03-01T09:53:43-05:00",
         "marketing_opt_in_level": null,
         "tax_exemptions": [],
         "email_marketing_consent": {
             "state": "not_subscribed",
             "opt_in_level": "single_opt_in",
             "consent_updated_at": null
         },
         "sms_marketing_consent": null,
         "admin_graphql_api_id": "gid://shopify/Customer/6851778085169",
         "default_address": {
             "id": 9107861078321,
             "customer_id": 6851778085169,
             "first_name": "ahmed",
             "last_name": "ali",
             "company": null,
             "address1": "cairo",
             "address2": null,
             "city": "cairo",
             "province": "Dakahlia",
             "country": "Egypt",
             "zip": "3554",
             "phone": "",
             "name": "ahmed ali",
             "province_code": "DK",
             "country_code": "EG",
             "country_name": "Egypt",
             "default": true
         }
     }
 }
 */
