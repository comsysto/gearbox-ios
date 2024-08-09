//
//  SignInUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation

class SignInUseCase {
  private let authenticationRepository: AuthenticationRepository
  
  init(_ authenticationRepository: AuthenticationRepository) {
    self.authenticationRepository = authenticationRepository
  }
  
  func execute(email: String, password: String) async -> Result<User, AuthError> {
    return await authenticationRepository.signIn(email: email, password: password)
  }
}
