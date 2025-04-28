//
//  KeychaingUserSessionRepository.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.04.2025..
//
import Foundation
import SwiftUI

class KeychainUserSessionRepository: UserSessionRepositoryType {
  @KeychainStorage("userId") private var userId: String
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  
  func saveSession(_ session: UserSession) {
    self.userId = session.userId
    self.accessToken = session.token.accessToken
    self.refreshToken = session.token.refreshToken
  }
  
  func getSession() -> UserSession {
    let token = Token(accessToken: self.accessToken, refreshToken: self.refreshToken)
    return UserSession(userId: self.userId, token: token)
  }
  
  func clearSession() {
    self.userId = ""
    self.accessToken = ""
    self.refreshToken = ""
  }
}
