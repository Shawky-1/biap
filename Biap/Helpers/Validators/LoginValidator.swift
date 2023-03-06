//
//  LoginValidator.swift
//  Biap
//
//  Created by Ahmed Shawky on 04/03/2023.
//

import Foundation


class LoginValidator {
    

    
    func validate(email: String?, password: String?) throws {
        
        guard let email = email, let password = password else {
            throw LoginError.invalidEmail
        }
        
        // Validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            throw LoginError.invalidEmail
        }
        
        // Validate password length
        if password.count < 8 {
            throw LoginError.invalidPassword
        }
        
        // Password validation rules can be added as needed
        
    }
}
