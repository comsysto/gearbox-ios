//
//  File.swift
//  
//
//  Created by Filip Kisić on 01.08.2024..
//

import Foundation

public struct SignInRequest: Codable {
  let email: String
  let password: String
  
  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}

public struct SignUpRequest: Codable {
  let email: String
  let username: String
  let password: String
  let confirmPassword: String
  
  public init(email: String, username: String, password: String, confirmPassword: String) {
    self.email = email
    self.username = username
    self.password = password
    self.confirmPassword = confirmPassword
  }
}

public struct AuthenticationResponse: Identifiable, Decodable {
  public let token: String
  public let refreshToken: String
  public let id: String
  public let email: String
  public let username: String
  public let profileImageUrl: String?
}
