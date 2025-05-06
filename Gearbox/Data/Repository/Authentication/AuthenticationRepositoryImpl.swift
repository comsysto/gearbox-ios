//
//  AuthenticationRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation
import RemoteDatasource

class AuthenticationRepositoryImpl: AuthenticationRepositoryType {
  // MARK: - DEPENDECIES
  private let authApi: AuthenticationDatasourceType
  private let userSessionRepository: UserSessionRepositoryType
  
  private let authenticationResponseToUserEntityConverter: AuthenticationResponseToUserEntityConverter
  
  // MARK: - CONSTRUCTOR
  init(
    _ authenticationDatasource: AuthenticationDatasourceType,
    _ userSessionRepository: UserSessionRepositoryType,
    _ authenticationResponseToUserEntityConverter: AuthenticationResponseToUserEntityConverter
  ) {
    self.authApi = authenticationDatasource
    self.userSessionRepository = userSessionRepository
    self.authenticationResponseToUserEntityConverter = authenticationResponseToUserEntityConverter
  }
  
  // MARK: - FUNCTIONS
  func signIn(email: String, password: String) async -> Result<User, AuthError> {
    do {
      let request = SignInRequest(email: email, password: password)
      let response = try await authApi.signIn(request: request)
      let user = authenticationResponseToUserEntityConverter.convert(response)
      
      let session = UserSession(userId: user.id, token: user.token)
      userSessionRepository.saveSession(session)
      
      return .success(user)
    } catch {
      return .failure(handleAuthExceptions(error))
    }
  }
  
  func signUp(email: String, username: String, password: String, confirmPassword: String) async -> Result<User, AuthError> {
    do {
      let request = SignUpRequest(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword
      )
      let response = try await authApi.signUp(request: request)
      let user = authenticationResponseToUserEntityConverter.convert(response)
      
      let session = UserSession(userId: user.id, token: user.token)
      userSessionRepository.saveSession(session)
      
      return .success(user)
    } catch {
      return .failure(handleAuthExceptions(error))
    }
  }
  
  func refreshUserSession() async -> Result<User, AuthError> {
    do {
      let token = userSessionRepository.getSession().token
      
      let request = RefreshTokenRequest(token.refreshToken)
      let response = try await authApi.refreshToken(request: request)
      let user = authenticationResponseToUserEntityConverter.convert(response)
      
      let session = UserSession(userId: user.id, token: user.token)
      userSessionRepository.saveSession(session)
      
      return .success(user)
    } catch {
      userSessionRepository.clearSession()
      return .failure(handleAuthExceptions(error))
    }
  }
  
  private func handleAuthExceptions(_ error: Error) -> AuthError {
    switch error as? AuthenticationException {
      case .invalidRequest(let message):
        return AuthError.invalidRequest(message)
      case .userNotFound(let message):
        return AuthError.userNotFound(message)
      case .userAlreadyExists(let message):
        return AuthError.userAlreadyExists(message)
      case .expiredToken(let message):
        return AuthError.expiredToken(message)
      case .serverError(let message):
        return .serverError(message)
      default:
        return AuthError.serverError("error.unknown")
    }
  }
}
