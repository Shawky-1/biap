//
//  LoginErrors.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//

import Foundation

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
    case networkError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("Invalid email", comment: "Error message displayed when the entered email is invalid")
        case .invalidPassword:
            return "Invalid password"
        case .networkError:
            return "Unable to connect to the server. Please check your internet connection and try again."
        case .unknownError:
            return "An unknown error occurred. Please try again later."
        }
    }
}
