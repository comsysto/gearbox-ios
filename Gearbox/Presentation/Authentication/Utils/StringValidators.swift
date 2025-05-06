//
//  TextFieldTypeValidator.swift
//  Gearbox
//
//  Created by Filip Kisić on 12.07.2024..
//

import Foundation

extension String {
  static func empty() -> String {
    return " "
  }
  
  func validateAsEmail() -> String? {
    let isValid = doesMatchRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    
    if self.isEmpty {
      return "authentication.error.empty"
    }
    
    if !isValid {
      return "authentication.error.invalid-email"
    }
    
    return nil
  }
  
  func validateAsPassword() -> String? {
    let isValid = doesMatchRegex("^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$")
    
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
  
  func validateAsUsername() -> String? {
    let isValid = doesMatchRegex("[a-z]+[a-zA-Z0-9]{4,}")
    
    if self.isEmpty {
      return "authentication.error.empty"
    }
    
    if self.first!.isUppercase{
      return "authentication.error.username-captialized"
    }
    
    if self.count < 5 {
      return "authentication.error.username-too-short"
    }
    
    if !isValid {
      return "authentication.error.username-characters"
    }
    
    return nil
  }
  
  private func doesMatchRegex(_ regex: String) -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: self)
  }
}
