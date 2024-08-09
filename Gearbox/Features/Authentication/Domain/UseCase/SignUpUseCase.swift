//
//  SignUpUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation

class SignUpUseCase {
  private let authRepository: AuthenticationRepository
  
  init(_ authRepository: AuthenticationRepository) {
    self.authRepository = authRepository
  }
  
  func execute(email: String, username: String, password: String, confirmPassword: String) async -> Result<User, AuthError> {
    return await authRepository.signUp(email: email, username: username, password: password, confirmPassword: confirmPassword)
  }
}
