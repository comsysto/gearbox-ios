//
//  SignUpUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation

class SignUpUseCase {
  private let repository: AuthenticationRepositoryType
  
  init(_ repository: AuthenticationRepositoryType) {
    self.repository = repository
  }
  
  func execute(
    email: String,
    username: String,
    password: String,
    confirmPassword: String
  ) async -> Result<User, AuthError> {
    return await repository.signUp(
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword
    )
  }
}
