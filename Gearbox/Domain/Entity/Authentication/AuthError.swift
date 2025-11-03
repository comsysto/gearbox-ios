//
//  AuthenticationErrorHandler.swift
//  Gearbox
//
//  Created by Filip Kisić on 09.08.2024..
//

import Foundation

enum AuthError: Error, Equatable {
  case invalidRequest(_ message: String)
  case userNotFound(_ message: String)
  case userAlreadyExists(_ message: String)
  case expiredToken(_ message: String)
  case serverError(_ message: String)
}

