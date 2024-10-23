//
//  FormValidators.swift
//  Gearbox
//
//  Created by Filip Kisić on 23.10.2024..
//

class FormValidator {
  static func validate(
    _ value: String,
    for rule: ValidationRules,
    with another: String? = nil
  ) -> String? {
    switch rule {
      case .empty:
        return value.isEmpty ? "authentication.error.empty" : nil
      case .email:
        return value.validateAsEmail()
      case .username:
        return value.validateAsUsername()
      case .passwordsMatch:
        return value == another ? "authentication.error.password-mismatch" : nil
      case .passwordObeyPolicy:
        return value.validateAsPassword()
    }
  }
}

enum ValidationRules {
  case empty
  case email
  case username
  case passwordsMatch
  case passwordObeyPolicy
}
