//
//  ProfileError.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.04.2025..
//

enum ProfileError: Error, Equatable {
  case serverError(_ message: String)
  case imageCompressionFailed(_ message: String)
  
  var message: String {
    switch self {
      case .serverError(let message):
        return message
      case .imageCompressionFailed(let message):
        return message
    }
  }
}
