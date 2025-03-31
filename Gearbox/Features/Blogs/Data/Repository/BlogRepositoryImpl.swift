//
//  BlogRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation
import GearboxDatasource

class BlogRepositoryImpl: BlogRepositoryType {
  private let blogApi: BlogDatasourceType
  private let userLocalDataSource: UserLocalDatasource
  private let blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
  
  init(
    _ blogApi: BlogDatasourceType,
    _ userlocalDataSource: UserLocalDatasource,
    _ blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  ) {
    self.blogApi = blogApi
    self.userLocalDataSource = userlocalDataSource
    self.blogResponseToBlogEntity = blogResponseToBlogEntity
  }
  
  func getTrendingBlogs() async -> Result<[Blog], BlogError> {
    do {
      let accessToken = userLocalDataSource.loadToken()
      let request = BlogPageableSecureRequest(token: accessToken.token, page: 0, size: 5)
      
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
  
  func getLatestBlogs(_ nextPage: Bool) async -> Result<[Blog], BlogError> {
    do {
      if nextPage == false {
        currentPage = 0
        isLastPage = false
      }
      
      guard !isLastPage else { return .success([])}
      
      if nextPage { currentPage += 1 }
      
      let accessToken = userLocalDataSource.loadToken()
      let request = BlogPageableSecureRequest(token: accessToken.token, page: currentPage, size: 6)
      
      let response = try await blogApi.getLatest(request)
      
      isLastPage = response.last
      
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
  
  func searchBlogs(query: String, _ nextPage: Bool) async -> Result<[Blog], BlogError> {
    do {
      if nextPage == false {
        currentPage = 0
        isLastPage = false
      }
      
      guard !isLastPage else { return .success([])}
      
      if nextPage { currentPage += 1 }
      
      let accessToken = userLocalDataSource.loadToken()
      let request = BlogPageableSecureRequest(token: accessToken.token, page: currentPage, size: 8)
      
      let response = try await blogApi.search(request, query: query)
      
      isLastPage = response.last
      
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
}
