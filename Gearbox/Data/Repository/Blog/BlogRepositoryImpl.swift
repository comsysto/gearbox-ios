//
//  BlogRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation
import RemoteDatasource

class BlogRepositoryImpl: BlogRepositoryType {
  private let blogApi: BlogDatasourceType
  private let userSessionRepository: UserSessionRepositoryType
  private let blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  
  init(
    _ blogApi: BlogDatasourceType,
    _ userSessionRepository: UserSessionRepositoryType,
    _ blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  ) {
    self.blogApi = blogApi
    self.userSessionRepository = userSessionRepository
    self.blogResponseToBlogEntity = blogResponseToBlogEntity
  }
  
  func getTrendingBlogs() async -> Result<[Blog], BlogError> {
    do {
      let token = userSessionRepository.getSession().token
      let request = BlogPageableSecureRequest(token: token.accessToken, page: 0, size: 5)
      
      let response = try await blogApi.getTrending(request)
      
      let blogList = response.content.map(blogResponseToBlogEntity.convert)
      return .success(blogList)
    } catch {
      switch error as? BlogError {
        case .serverError(let message):
          return .failure(.serverError(message))
        default:
          return .failure(.serverError("error.unknown"))
      }
    }
  }
  
  func getLatestBlogs(page: Int, size: Int) async -> Result<Paginated<Blog>, BlogError> {
    do {
      let token = userSessionRepository.getSession().token
      let request = BlogPageableSecureRequest(token: token.accessToken, page: page, size: size)
      
      let response = try await blogApi.getLatest(request)
      
      let blogList = response.content.map(blogResponseToBlogEntity.convert)
      let paginated = Paginated(items: blogList, isLastPage: response.last)
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
  
  func searchBlogs(query: String, page: Int, size: Int) async -> Result<Paginated<Blog>, BlogError> {
    do {
      let token = userSessionRepository.getSession().token
      let request = BlogPageableSecureRequest(token: token.accessToken, page: page, size: size)
      
      let response = try await blogApi.search(request, query: query)
      
      let blogList = response.content.map(blogResponseToBlogEntity.convert)
      let paginated = Paginated(items: blogList, isLastPage: response.last)
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
