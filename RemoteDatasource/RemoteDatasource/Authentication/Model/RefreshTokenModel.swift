//
//  File.swift
//  
//
//  Created by Filip Kisić on 18.08.2024..
//

import Foundation

public struct RefreshTokenRequest: Codable {
  let refreshToken: String
  
  public init(_ refreshToken: String) {
    self.refreshToken = refreshToken
  }
}
