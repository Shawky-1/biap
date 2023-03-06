//
//  Customer.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//

import Foundation

struct CustomersResponse: Codable {
    let customers: [Customer]
}

struct CustomerResponse: Codable {
    let customer: Customer
}

struct Customer: Codable {
    let id: Int
    let email: String
    let acceptsMarketing: Bool
    let createdAt: String
    let updatedAt: String
    let firstName: String?
    let lastName: String?
    let ordersCount: Int
    let state: String
    let totalSpent: String
    let lastOrderId: Int?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let phone: String?
    let tags: String
    let lastOrderName: String?
    let currency: String
    let addresses: [Address]
    let acceptsMarketingUpdatedAt: String
    let marketingOptInLevel: String?
    let taxExemptions: [String]
    let adminGraphqlApiId: String
    let defaultAddress: Address?
    
    enum CodingKeys: String, CodingKey {
        case id, email, state, phone, tags, currency, addresses, note
        case acceptsMarketing = "accepts_marketing"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case totalSpent = "total_spent"
        case lastOrderId = "last_order_id"
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case lastOrderName = "last_order_name"
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case marketingOptInLevel = "marketing_opt_in_level"
        case taxExemptions = "tax_exemptions"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
    init(email: String, firstName: String?, lastName: String?, note: String?, phone: String?) {
        self.id = 0
        self.email = email
        self.acceptsMarketing = false
        self.createdAt = ""
        self.updatedAt = ""
        self.firstName = firstName
        self.lastName = lastName
        self.ordersCount = 0
        self.state = ""
        self.totalSpent = ""
        self.lastOrderId = 0
        self.note = note
        self.verifiedEmail = false
        self.multipassIdentifier = ""
        self.taxExempt = false
        self.phone = phone
        self.tags = ""
        self.lastOrderName = ""
        self.currency = ""
        self.addresses = []
        self.acceptsMarketingUpdatedAt = ""
        self.marketingOptInLevel = ""
        self.taxExemptions = [""]
        self.adminGraphqlApiId = ""
        self.defaultAddress = nil
    }
}

struct Address: Codable {
    let id: Int
    let customerId: Int
    let firstName: String
    let lastName: String
    let company: String?
    let address1: String
    let address2: String?
    let city: String
    let province: String
    let country: String
    let zip: String
    let phone: String
    let name: String
    let provinceCode: String
    let countryCode: String
    let countryName: String
    let isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, city, province, country, zip, phone, name
        case customerId = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company = "company"
        case address1 = "address1"
        case address2 = "address2"
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case isDefault = "default"
    }
}
