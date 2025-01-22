//
//  File.swift
//  
//
//  Created by Filip Kisić on 12.09.2024..
//

import Foundation

public protocol BlogDatasource {
  func getTrending(blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]>
}

public enum BlogException: Error {
  case serverError(_ message: String)
  case blogUserNotFound(_ message: String)
  case blogNotFound(_ message: String)
}
