//
//  DependecyInjectionContainer.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency

// MARK: - DATASOURCE
private struct UserLocalDatasourceKey: DependencyKey {
  static var currentValue: UserLocalDatasource = UserLocalDatasource()
}

// MARK: - MAPPERS
private struct AuthenticationResponseToUserEntityConverterKey: DependencyKey {
  static var currentValue: AuthenticationResponseToUserEntityConverter = AuthenticationResponseToUserEntityConverter()
}

private struct RefreshTokenResponseToTokenEntityConverterKey: DependencyKey {
  static var currentValue: RefreshTokenResponseToTokenEntityConverter = RefreshTokenResponseToTokenEntityConverter()
}

// MARK: - REPOSITORY
private struct AuthenticationRepositoryKey: DependencyKey {
  @Dependency(\.authenticationDatasourceKey) private static var authDatasource
  @Dependency(\.userLocalDatasourceKey) private static var userLocalDatasource
  @Dependency(\.authenticationResponseToUserEntityConverterKey) private static var authenticationResponseToUserEntityConverterKey
  @Dependency(\.refreshTokenResponseToTokenEntityConverterKey) private static var refreshTokenResponseToTokenEntityConverterKey
  
  static var currentValue: AuthenticationRepository = AuthenticationRepositoryImpl(
    authDatasource,
    userLocalDatasource,
    authenticationResponseToUserEntityConverterKey,
    refreshTokenResponseToTokenEntityConverterKey
  )
}

// MARK: - USE CASE
private struct SignInUseCaseKey: DependencyKey {
  @Dependency(\.authenticationRepository) private static var repository
  
  static var currentValue: SignInUseCase = SignInUseCase(repository)
}

private struct SignUpUseCaseKey: DependencyKey {
  @Dependency(\.authenticationRepository) private static var repository
  
  static var currentValue: SignUpUseCase = SignUpUseCase(repository)
}

private struct RefreshUserSessionUseCaseKey: DependencyKey {
  @Dependency(\.authenticationRepository) private static var repository
  
  static var currentValue: RefreshUserSessionUseCase = RefreshUserSessionUseCase(repository)
}


// MARK: - GETTERS
extension DependencyValues {
  var userLocalDatasourceKey: UserLocalDatasource {
    get { Self[UserLocalDatasourceKey.self] }
    set { Self[UserLocalDatasourceKey.self] = newValue }
  }
  
  var authenticationResponseToUserEntityConverterKey: AuthenticationResponseToUserEntityConverter {
    get { Self[AuthenticationResponseToUserEntityConverterKey.self] }
    set { Self[AuthenticationResponseToUserEntityConverterKey.self] = newValue }
  }
  
  var refreshTokenResponseToTokenEntityConverterKey: RefreshTokenResponseToTokenEntityConverter {
    get { Self[RefreshTokenResponseToTokenEntityConverterKey.self] }
    set { Self[RefreshTokenResponseToTokenEntityConverterKey.self] = newValue }
  }
  
  var authenticationRepository: AuthenticationRepository {
    get { Self[AuthenticationRepositoryKey.self] }
    set { Self[AuthenticationRepositoryKey.self] = newValue}
  }  
  
  var signInUseCase: SignInUseCase {
    get { Self[SignInUseCaseKey.self] }
    set { Self[SignInUseCaseKey.self] = newValue}
  }
  
  var signUpUseCase: SignUpUseCase {
    get { Self[SignUpUseCaseKey.self] }
    set { Self[SignUpUseCaseKey.self] = newValue}
  }
  
  var refreshUserSessionUseCase: RefreshUserSessionUseCase {
    get { Self[RefreshUserSessionUseCaseKey.self] }
    set { Self[RefreshUserSessionUseCaseKey.self] = newValue }
  }
}

