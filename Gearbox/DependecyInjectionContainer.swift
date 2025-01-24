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

// MARK: - MAPPER
private struct AuthenticationResponseToUserEntityConverterKey: DependencyKey {
  static var currentValue: AuthenticationResponseToUserEntityConverter = AuthenticationResponseToUserEntityConverter()
}

private struct BlogResponseToBlogEntityConverterKey: DependencyKey {
  static var currentValue: BlogResponseToBlogEntityConverter = BlogResponseToBlogEntityConverter()
}

// MARK: - REPOSITORY
private struct AuthenticationRepositoryKey: DependencyKey {
  @Dependency(\.authenticationDatasourceKey) private static var authDatasource
  @Dependency(\.userLocalDatasourceKey) private static var userLocalDatasource
  @Dependency(\.authenticationResponseToUserEntityConverterKey) private static var authenticationResponseToUserEntityConverterKey
  
  static var currentValue: AuthenticationRepositoryType = AuthenticationRepositoryImpl(
    authDatasource,
    userLocalDatasource,
    authenticationResponseToUserEntityConverterKey
  )
}

private struct BlogRepositoryKey: DependencyKey {
  @Dependency(\.blogDatasourceKey) private static var blogDatasource
  @Dependency(\.userLocalDatasourceKey) private static var userLocalDatasource
  @Dependency(\.blogResponseToBlogEntityConverterKey) private static var blogResponseToBlogEntityConverterKey
  
  static var currentValue: BlogRepositoryType = BlogRepositoryImpl(
    blogDatasource,
    userLocalDatasource,
    blogResponseToBlogEntityConverterKey
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

private struct GetTrendingBlogsUseCaseKey: DependencyKey {
  @Dependency(\.blogRepository) private static var repository
  
  static var currentValue: GetTrendingBlogsUseCase = GetTrendingBlogsUseCase(repository)
}


// MARK: - GETTERS
extension DependencyValues {
  // MARK: - DATASOURCE
  var userLocalDatasourceKey: UserLocalDatasource {
    get { Self[UserLocalDatasourceKey.self] }
    set { Self[UserLocalDatasourceKey.self] = newValue }
  }
  
  // MARK: - MAPPER
  var authenticationResponseToUserEntityConverterKey: AuthenticationResponseToUserEntityConverter {
    get { Self[AuthenticationResponseToUserEntityConverterKey.self] }
    set { Self[AuthenticationResponseToUserEntityConverterKey.self] = newValue }
  }
  
  var blogResponseToBlogEntityConverterKey: BlogResponseToBlogEntityConverter {
    get { Self[BlogResponseToBlogEntityConverterKey.self] }
    set { Self[BlogResponseToBlogEntityConverterKey.self] = newValue }
  }
  
  // MARK: - REPOSITORY
  var authenticationRepository: AuthenticationRepositoryType {
    get { Self[AuthenticationRepositoryKey.self] }
    set { Self[AuthenticationRepositoryKey.self] = newValue}
  }
  
  var blogRepository: BlogRepositoryType {
    get { Self[BlogRepositoryKey.self] }
    set { Self[BlogRepositoryKey.self] = newValue}
  }  
  
  // MARK: - USE CASE
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
  
  var getTrendingBlogsUseCase: GetTrendingBlogsUseCase {
    get { Self[GetTrendingBlogsUseCaseKey.self] }
    set { Self[GetTrendingBlogsUseCaseKey.self] = newValue }
  }
}

