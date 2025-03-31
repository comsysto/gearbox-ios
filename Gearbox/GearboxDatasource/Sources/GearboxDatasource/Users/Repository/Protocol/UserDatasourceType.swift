//
//  UserDatasource.swift
//  GearboxDatasource
//
//  Created by Filip Kisić on 28.03.2025..
//
import Foundation

public protocol UserDatasourceType {
  func search(_ userRequest: UserPageableSecureRequest, query: String) async throws -> PageableResponse<[UserResponse]>
}

public enum UserException: Error {
  case serverError(_ message: String)
}
