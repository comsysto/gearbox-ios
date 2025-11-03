//
//  UserRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 31.03.2025..
//
import Foundation
import RemoteDatasource

class AuthorRepositoryImpl: AuthorRepositoryType {
  private let userApi: UserDatasourceType
  private let userSessionRepository: UserSessionRepositoryType
  private let authorResponseToAuthorEntity: AuthorResponseToAuthorEntityConverter
  
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
  
  init(
    _ userApi: UserDatasourceType,
    _ userSessionRepository: UserSessionRepositoryType,
    _ authorResponseToAuthorEntity: AuthorResponseToAuthorEntityConverter
  ) {
    self.userApi = userApi
    self.userSessionRepository = userSessionRepository
    self.authorResponseToAuthorEntity = authorResponseToAuthorEntity
  }
  
  func search(query: String, page: Int, size: Int) async -> Result<Paginated<Author>, BlogError> {
    do {
      let token = userSessionRepository.getSession().token
      let request = UserPageableSecureRequest(token: token.accessToken, page: page, size: size)
      
      let response = try await userApi.search(request, query: query)
      
      let authorList = response.content.map(authorResponseToAuthorEntity.convert)
      let paginated = Paginated(items: authorList, isLastPage: response.last)
      return .success(paginated)
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
