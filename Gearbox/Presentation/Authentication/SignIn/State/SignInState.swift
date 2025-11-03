//
//  SignInState.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.10.2024..
//

struct SignInState: Equatable {
  var email: String = ""
  var emailValidationMessage: String?
  
  var password: String = ""
  var passwordValidationMessage: String?
  
  var isLoading: Bool = false
  
  var isErrorShown: Bool = false
  var errorMessage: String = ""
  
  var authState: SignInAuthState = .unauthenticated
}

enum SignInAuthState: Equatable {
  case loading
  case authenticated
  case unauthenticated
}
