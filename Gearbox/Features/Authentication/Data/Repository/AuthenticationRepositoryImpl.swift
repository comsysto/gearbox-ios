//
//  AuthenticationRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation
import GearboxDatasource

class AuthenticationRepositoryImpl: AuthenticationRepository {
  private let authApi: AuthenticationDatasource
  private let responseToEntityConverter: AuthenticationResponseToUserEntityConverter
  
  init(_ authenticationDatasource: AuthenticationDatasource,_ responseToEntityMapper: AuthenticationResponseToUserEntityConverter) {
    self.authApi = authenticationDatasource
    self.responseToEntityConverter = responseToEntityMapper
  }
  
  func signIn(email: String, password: String) async -> Result<User, AuthError> {
    do {
      let request = SignInRequest(email: email, password: password)
      let response = try await authApi.signIn(request: request)
      let user = responseToEntityConverter.convert(response)
      return .success(user)
    } catch {
      return .failure(handleAuthExceptions(error))
    }
  }
  
  func signUp(email: String, username: String, password: String, confirmPassword: String) async -> Result<User, AuthError> {
    do {
      let request = SignUpRequest(email: email, username: username, password: password, confirmPassword: confirmPassword)
      let response = try await authApi.signUp(request: request)
      let user = responseToEntityConverter.convert(response)
      return .success(user)
    } catch {
      return .failure(handleAuthExceptions(error))
    }
  }
  
  private func handleAuthExceptions(_ error: Error) -> AuthError {
    switch error as! AuthenticationException {
      case .invalidRequest(let message):
        return AuthError.invalidRequest(message)
      case .userNotFound(let message):
        return AuthError.userNotFound(message)
      case .userAlreadyExists(let message):
        return AuthError.userAlreadyExists(message)
      case .serverError(let message):
        return .serverError(message)
      default:
        return AuthError.serverError("Unknown error.")
    }
  }
}
