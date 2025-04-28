//
//  File.swift
//  
//
//  Created by Filip Kisić on 12.09.2024..
//

import Foundation

public protocol BlogDatasourceType {
  func getTrending(_ blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]>
  func getLatest(_ blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]>
  func search(_ blogRequest: BlogPageableSecureRequest, query: String) async throws -> PageableResponse<[BlogResponse]>
  func getByAuthor(_ blogRequest: BlogPageableSecureRequest, userId: String) async throws -> PageableResponse<[BlogResponse]>
  func getLikedBy(_ blogRequest: BlogPageableSecureRequest, userId: String) async throws -> PageableResponse<[BlogResponse]>
}

public enum BlogException: Error {
  case serverError(_ message: String)
  case blogUserNotFound(_ message: String)
  case blogNotFound(_ message: String)
}
