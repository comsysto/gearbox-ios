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
  private let userSessionRepository: UserSessionRepositoryType
  private let userResponseToProfileData: UserResponseToProfileDataConverter
  
  init(
    _ profileApi: UserDatasourceType,
    _ userSessionRepository: UserSessionRepositoryType,
    _ userResponseToProfileData: UserResponseToProfileDataConverter
  ) {
    self.profileApi = profileApi
    self.userSessionRepository = userSessionRepository
    self.userResponseToProfileData = userResponseToProfileData
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
}
