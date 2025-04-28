//
//  UserDatasource.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 28.03.2025..
//
import Foundation

public protocol UserDatasourceType {
  func search(_ userRequest: UserPageableSecureRequest, query: String) async throws -> PageableResponse<[UserResponse]>
  func getProfileData(_ userRequest: UserSecureRequest) async throws -> UserResponse
  func uploadProfileImage(token: String, userId: String, image: Data) async throws -> UserResponse
}

public enum UserException: Error {
  case serverError(_ message: String)
}
