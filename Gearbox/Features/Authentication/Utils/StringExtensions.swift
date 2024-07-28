//
//  TextFieldTypeValidator.swift
//  Gearbox
//
//  Created by Filip Kisić on 12.07.2024..
//

import Foundation

enum InputType {
  case email, password
}

extension String {
  func validateAsEmail() -> String? {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    let isValid = emailPredicate.evaluate(with: self)
    
    if self.isEmpty {
      return "authentication.error.empty"
    }
    
    if !isValid {
      return "authentication.error.invalid-email"
    }
    
    return nil
  }
  
  func validateAsPassword() -> String? {
    let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    let isValid = passwordPredicate.evaluate(with: self)
    
    if self.isEmpty {
      return "authentication.error.empty"
    }
    
    if self.count < 8 {
      return "authentication.error.password-too-short"
    }
    
    if !isValid {
      return "authentication.error.invalid-password"
    }
    
    return nil
  }
}
