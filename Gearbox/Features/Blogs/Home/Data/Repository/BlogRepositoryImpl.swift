//
//  BlogRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation
import GearboxDatasource

class BlogRepositoryImpl: BlogRepositoryType {
  private let blogApi: BlogDatasource
  private let userLocalDataSource: UserLocalDatasource
  private let blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  
  init(
    _ blogApi: BlogDatasource,
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
      let request = BlogPageableSecureRequest(token: accessToken.token, page: 0, size: 10) //TODO: Refactor this values
      
      let response = try await blogApi.getTrending(blogRequest: request)
      
      print("Response: \(response)")
      
      let blogList = response.content.map(blogResponseToBlogEntity.convert)
      return .success(blogList)
    } catch {
      switch error as? BlogError {
        case .serverError(let message):
          print("Server error: \(message)")
          return .failure(.serverError(message))
        default:
          print("Unknown error")
          return .failure(.serverError("error.unknown"))
      }
    }
  }
}
