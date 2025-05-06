//
//  DependecyInjectionContainer.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency

// MARK: - MAPPER
private struct AuthenticationResponseToUserEntityConverterKey: DependencyKey {
  static var currentValue: AuthenticationResponseToUserEntityConverter = AuthenticationResponseToUserEntityConverter()
}

private struct BlogResponseToBlogEntityConverterKey: DependencyKey {
  static var currentValue: BlogResponseToBlogEntityConverter = BlogResponseToBlogEntityConverter()
}

private struct AuthorResponseToAuthorEntityConverterKey: DependencyKey {
  static var currentValue: AuthorResponseToAuthorEntityConverter = AuthorResponseToAuthorEntityConverter()
}

private struct UserResponseToProfileDataConverterKey: DependencyKey {
  static var currentValue: UserResponseToProfileDataConverter = UserResponseToProfileDataConverter()
}

// MARK: - REPOSITORY
private struct UserSessionRepositoryKey: DependencyKey {
  static var currentValue: UserSessionRepositoryType = KeychainUserSessionRepository()
}

private struct AuthenticationRepositoryKey: DependencyKey {
  @Dependency(\.authenticationDatasourceKey) private static var authDatasource
  @Dependency(\.userSessionRepositoryKey) private static var userSesssionRepository
  @Dependency(\.authenticationResponseToUserEntityConverterKey) private static var authenticationResponseToUserEntityConverter
  
  static var currentValue: AuthenticationRepositoryType = AuthenticationRepositoryImpl(
    authDatasource,
    userSesssionRepository,
    authenticationResponseToUserEntityConverter
  )
}

private struct BlogRepositoryKey: DependencyKey {
  @Dependency(\.blogDatasourceKey) private static var blogDatasource
  @Dependency(\.userSessionRepositoryKey) private static var userSesssionRepository
  @Dependency(\.blogResponseToBlogEntityConverterKey) private static var blogResponseToBlogEntityConverter
  
  static var currentValue: BlogRepositoryType = BlogRepositoryImpl(
    blogDatasource,
    userSesssionRepository,
    blogResponseToBlogEntityConverter
  )
}

private struct AuthorRepositoryKey: DependencyKey {
  @Dependency(\.userDatasourceKey) private static var authorDatasource
  @Dependency(\.userSessionRepositoryKey) private static var userSesssionRepository
  @Dependency(\.authorResponseToAuthorEntityConverterKey) private static var authorResponseToAuthorEntityConverter
  
  static var currentValue: AuthorRepositoryType = AuthorRepositoryImpl(
    authorDatasource,
    userSesssionRepository,
    authorResponseToAuthorEntityConverter
  )
}

private struct ProfileRepositoryKey: DependencyKey {
  @Dependency(\.userDatasourceKey) private static var userDatasource
  @Dependency(\.blogDatasourceKey) private static var blogDatasource
  @Dependency(\.userSessionRepositoryKey) private static var userSesssionRepository
  @Dependency(\.userResponseToProfileDataConverterKey) private static var userResponseToProfileDataConverter
  @Dependency(\.blogResponseToBlogEntityConverterKey) private static var blogResponseToBlogEntityConverter
  
  static var currentValue: ProfileRepositoryType = ProfileRepositoryImpl(
    userDatasource,
    blogDatasource,
    userSesssionRepository,
    userResponseToProfileDataConverter,
    blogResponseToBlogEntityConverter
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

private struct GetLatestBlogsUseCaseKey: DependencyKey {
  @Dependency(\.blogRepository) private static var repository
  
  static var currentValue: GetLatestBlogsUseCase = GetLatestBlogsUseCase(repository)
}

private struct SearchBlogsUseCaseKey: DependencyKey {
  @Dependency(\.blogRepository) private static var repository
  
  static var currentValue: SearchBlogsUseCase = SearchBlogsUseCase(repository)
}

private struct SearchUsersUseCaseKey: DependencyKey {
  @Dependency(\.authorRepository) private static var repository
  
  static var currentValue: SearchUsersUseCase = SearchUsersUseCase(repository)
}

private struct CacheNewImagesUseCaseKey: DependencyKey {
  static var currentValue: CacheNewImagesUseCase = CacheNewImagesUseCase()
}

private struct UploadProfileImageUseCaseKey: DependencyKey {
  @Dependency(\.profileRepository) private static var repository
  
  static var currentValue: UploadProfileImageUseCase = UploadProfileImageUseCase(repository)
}

private struct GetProfileDataUseCaseKey: DependencyKey {
  @Dependency(\.profileRepository) private static var repository
  
  static var currentValue: GetProfileDataUseCase = GetProfileDataUseCase(repository)
}

private struct GetBlogsByAuthorIdUseCaseKey: DependencyKey {
  @Dependency(\.profileRepository) private static var repository
  
  static var currentValue: GetBlogsByAuthorIdUseCase = GetBlogsByAuthorIdUseCase(repository)
}

// MARK: - GETTERS
extension DependencyValues {
  // MARK: - MAPPER
  var authenticationResponseToUserEntityConverterKey: AuthenticationResponseToUserEntityConverter {
    get { Self[AuthenticationResponseToUserEntityConverterKey.self] }
    set { Self[AuthenticationResponseToUserEntityConverterKey.self] = newValue }
  }
  
  var blogResponseToBlogEntityConverterKey: BlogResponseToBlogEntityConverter {
    get { Self[BlogResponseToBlogEntityConverterKey.self] }
    set { Self[BlogResponseToBlogEntityConverterKey.self] = newValue }
  }
  
  var authorResponseToAuthorEntityConverterKey: AuthorResponseToAuthorEntityConverter {
    get { Self[AuthorResponseToAuthorEntityConverterKey.self] }
    set { Self[AuthorResponseToAuthorEntityConverterKey.self] = newValue }
  }
  
  var userResponseToProfileDataConverterKey: UserResponseToProfileDataConverter {
    get { Self[UserResponseToProfileDataConverterKey.self] }
    set { Self[UserResponseToProfileDataConverterKey.self] = newValue }
  }
  
  // MARK: - REPOSITORY
  var userSessionRepositoryKey: UserSessionRepositoryType {
    get { Self[UserSessionRepositoryKey.self] }
    set { Self[UserSessionRepositoryKey.self] = newValue }
  }
  
  var authenticationRepository: AuthenticationRepositoryType {
    get { Self[AuthenticationRepositoryKey.self] }
    set { Self[AuthenticationRepositoryKey.self] = newValue}
  }
  
  var blogRepository: BlogRepositoryType {
    get { Self[BlogRepositoryKey.self] }
    set { Self[BlogRepositoryKey.self] = newValue}
  }
  
  var authorRepository: AuthorRepositoryType {
    get { Self[AuthorRepositoryKey.self] }
    set { Self[AuthorRepositoryKey.self] = newValue}
  }
  
  var profileRepository: ProfileRepositoryType {
    get { Self[ProfileRepositoryKey.self] }
    set { Self[ProfileRepositoryKey.self] = newValue}
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
  
  var getLatestBlogsUseCase: GetLatestBlogsUseCase {
    get { Self[GetLatestBlogsUseCaseKey.self] }
    set { Self[GetLatestBlogsUseCaseKey.self] = newValue }
  }
  
  var searchBlogsUseCase: SearchBlogsUseCase {
    get { Self[SearchBlogsUseCaseKey.self] }
    set { Self[SearchBlogsUseCaseKey.self] = newValue }
  }
  
  var searchUsersUseCase: SearchUsersUseCase {
    get { Self[SearchUsersUseCaseKey.self] }
    set { Self[SearchUsersUseCaseKey.self] = newValue }
  }
  
  var cacheNewImagesUseCase: CacheNewImagesUseCase {
    get { Self[CacheNewImagesUseCaseKey.self] }
    set { Self[CacheNewImagesUseCaseKey.self] = newValue }
  }
  
  var uploadProfileImageUseCase: UploadProfileImageUseCase {
    get { Self[UploadProfileImageUseCaseKey.self] }
    set { Self[UploadProfileImageUseCaseKey.self] = newValue }
  }
  
  var getProfileDataUseCase: GetProfileDataUseCase {
    get { Self[GetProfileDataUseCaseKey.self] }
    set { Self[GetProfileDataUseCaseKey.self] = newValue }
  }
  
  var getBlogsByAuthorIdUseCase: GetBlogsByAuthorIdUseCase {
    get { Self[GetBlogsByAuthorIdUseCaseKey.self] }
    set { Self[GetBlogsByAuthorIdUseCaseKey.self] = newValue }
  }
}

