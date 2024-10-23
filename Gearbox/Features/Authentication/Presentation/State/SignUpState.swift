//
//  SignUpState.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.10.2024..
//

struct SignUpState: Equatable {
  var email: String = ""
  var emailValidationMessage: String?
  
  var username: String = ""
  var usernameValidationMessage: String?
  
  var password: String = ""
  var passwordValidationMessage: String?
  
  var confirmPassword: String = ""
  var confirmPasswordValidationMessage: String?
  
  var isLoading: Bool = false
  
  var isErrorShown: Bool = false
  var errorMessage: String = ""
  
  var authState: SignUpAuthState = .unauthenticated
}

enum SignUpAuthState: Equatable {
  case loading
  case authenticated
  case unauthenticated
}
