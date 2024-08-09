//
//  DependecyInjectionContainer.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency

// MARK: - MAPPERS
private struct AuthenticationResponseToUserEntityConverterKey: DependencyKey {
  static var currentValue: AuthenticationResponseToUserEntityConverter = AuthenticationResponseToUserEntityConverter()
}

// MARK: - REPOSITORY
private struct AuthenticationRepositoryKey: DependencyKey {
  @Dependency(\.authenticationDatasource) private static var authDatasource
  @Dependency(\.authenticationResponseToUserEntityConverterKey) private static var responseToEntityConverter
  
  static var currentValue: AuthenticationRepository = AuthenticationRepositoryImpl(authDatasource, responseToEntityConverter)
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


// MARK: - GETTERS
extension DependencyValues {
  var authenticationResponseToUserEntityConverterKey: AuthenticationResponseToUserEntityConverter {
    get { Self[AuthenticationResponseToUserEntityConverterKey.self] }
    set { Self[AuthenticationResponseToUserEntityConverterKey.self] = newValue }
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
}

