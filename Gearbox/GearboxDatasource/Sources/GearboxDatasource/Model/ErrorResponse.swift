//
//  File.swift
//  
//
//  Created by Filip Kisić on 08.08.2024..
//

import Foundation

public struct ErrorResponse: Decodable {
  let timestamp: String
  let message: String
}

extension ErrorResponse {
  func filterException() -> AuthenticationException {
    switch self.message {
      case "User is not found.":
        return AuthenticationException.userNotFound(self.message)
      case "User already exists.":
        return AuthenticationException.userAlreadyExists(self.message)
      default:
        return AuthenticationException.serverError(self.message)
    }
  }
}
