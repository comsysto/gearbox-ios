//
//  File.swift
//  
//
//  Created by Filip Kisić on 18.08.2024..
//

import Foundation

public struct RefreshTokenRequest: Encodable {
  let refreshToken: String
  
  public init(_ refreshToken: String) {
    self.refreshToken = refreshToken
  }
}

public struct RefreshTokenResponse: Decodable {
  public let token: String
  public let refreshToken: String
  
  public init(token: String, refreshToken: String) {
    self.token = token
    self.refreshToken = refreshToken
  }
}
