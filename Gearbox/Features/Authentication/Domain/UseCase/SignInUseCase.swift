//
//  SignInUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation

class SignInUseCase {
  private let repository: AuthenticationRepositoryType
  
  init(_ repository: AuthenticationRepositoryType) {
    self.repository = repository
  }
  
  func execute(email: String, password: String) async -> Result<User, AuthError> {
    return await repository.signIn(email: email, password: password)
  }
}
