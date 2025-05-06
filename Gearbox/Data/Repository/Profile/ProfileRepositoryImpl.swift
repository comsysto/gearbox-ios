//
//  ProfileRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.04.2025..
//
import Foundation
import RemoteDatasource

class ProfileRepositoryImpl: ProfileRepositoryType {
  private let profileApi: UserDatasourceType
  private let blogApi: BlogDatasourceType
  private let userSessionRepository: UserSessionRepositoryType
  private let userResponseToProfileData: UserResponseToProfileDataConverter
  private let blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
  
  init(
    _ profileApi: UserDatasourceType,
    _ blogApi: BlogDatasourceType,
    _ userSessionRepository: UserSessionRepositoryType,
    _ userResponseToProfileData: UserResponseToProfileDataConverter,
    _ blogResponseToBlogEntity: BlogResponseToBlogEntityConverter
  ) {
    self.profileApi = profileApi
    self.blogApi = blogApi
    self.userSessionRepository = userSessionRepository
    self.userResponseToProfileData = userResponseToProfileData
    self.blogResponseToBlogEntity = blogResponseToBlogEntity
  }
  
  func getProfileData(userId: String) async -> Result<ProfileData, ProfileError> {
    do {
      let session = userSessionRepository.getSession()
      
      let request = UserSecureRequest(token: session.token.accessToken, id: userId)
      
      let response = try await profileApi.getProfileData(request)
      
      return .success(userResponseToProfileData.convert(response))
    } catch {
      return .failure(.serverError("error.server-error"))
    }
  }
  
  func uploadProfileImage(image: Data) async -> Result<ProfileData, ProfileError> {
    do {
      let session = userSessionRepository.getSession()
      
      let response = try await profileApi.uploadProfileImage(
        token: session.token.accessToken,
        userId: session.userId,
        image: image
      )
      
      return .success(userResponseToProfileData.convert(response))
    } catch {
      return .failure(.serverError("error.server-error"))
    }
  }
  
  func getBlogsForProfile(userId: String, page: Int, size: Int) async -> Result<Paginated<Blog>, ProfileError> {
    do {
      let token = userSessionRepository.getSession().token
      
      let request = BlogPageableSecureRequest(token: token.accessToken, page: page, size: size)
      
      let response = try await blogApi.getByAuthor(request, userId: userId)
      let blogList = response.content.map(blogResponseToBlogEntity.convert)
      let blogPage = Paginated(items: blogList, isLastPage: response.last)
      return .success(blogPage)
    } catch {
      return .failure(.blogsNotFound("error.blogs-not-found"))
    }
  }
}
