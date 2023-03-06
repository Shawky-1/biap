//
//  APIErrors.swift
//  Biap
//
//  Created by Ahmed Shawky on 06/03/2023.
//

import Foundation
import Alamofire

struct APIError: Codable, Error {
    let errors: ErrorDetail
    
    struct ErrorDetail: Codable {
        let email: [String]?
        let phone: [String]?
    }
}


