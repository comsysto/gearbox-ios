//
//  RefreshTokenUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.08.2024..
//

import Foundation

class RefreshUserSessionUseCase {
  private let repository: AuthenticationRepository
  
  init(_ repository: AuthenticationRepository) {
    self.repository = repository
  }
  
  func execute() async -> Result<User, AuthError> {
    return await repository.refreshUserSession()
  }
}
