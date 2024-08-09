//
//  File.swift
//  
//
//  Created by Filip Kisić on 01.08.2024..
//

import Foundation

public struct AuthenticationResponse: Identifiable, Decodable {
  public let token: String
  public let refreshToken: String
  public let id: String
  public let email: String
  public let username: String
  public let profileImageUrl: String?
}
