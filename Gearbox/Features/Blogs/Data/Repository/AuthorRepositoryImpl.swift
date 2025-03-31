//
//  UserRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 31.03.2025..
//
import Foundation
import GearboxDatasource

class AuthorRepositoryImpl: AuthorRepositoryType {
  private let userApi: UserDatasourceType
  private let userLocalDataSource: UserLocalDatasource
  private let authorResponseToAuthorEntity: AuthorResponseToAuthorEntityConverter
  
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
  
  init(
    _ userApi: UserDatasourceType,
    _ userLocalDataSource: UserLocalDatasource,
    _ authorResponseToAuthorEntity: AuthorResponseToAuthorEntityConverter
  ) {
    self.userApi = userApi
    self.userLocalDataSource = userLocalDataSource
    self.authorResponseToAuthorEntity = authorResponseToAuthorEntity
  }
  
  func search(query: String, _ nextPage: Bool) async -> Result<[Author], BlogError> {
    do {
      if nextPage == false {
        currentPage = 0
        isLastPage = false
      }
      
      guard !isLastPage else { return .success([])}
      
      let accessToken = userLocalDataSource.loadToken()
      let request = UserPageableSecureRequest(token: accessToken.token, page: 0, size: 5)
      
      let response = try await userApi.search(request, query: query)
      
      isLastPage = response.last
      
      let authorList = response.content.map(authorResponseToAuthorEntity.convert)
      return .success(authorList)
    } catch {
      switch error as? BlogError {
        case .serverError(let message):
          return .failure(.serverError(message))
        default:
          return .failure(.serverError("error.unknown"))
      }
    }
  }
}
