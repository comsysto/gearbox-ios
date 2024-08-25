//
//  UserLocalStorage.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.08.2024..
//

import Foundation
import SwiftUI

class UserLocalDatasource {
  @KeychainStorage("userId") private var userId: String
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  
  @AppStorage("userEmail") private var email: String = ""
  @AppStorage("userName") private var username: String = ""
  @AppStorage("userProfileImageUrl") private var profileImageUrl: String = ""
  
  func saveUser(_ user: User) {
    self.userId = user.id
    self.email = user.email
    self.username = user.username
    self.profileImageUrl = user.profileImageUrl ?? ""
    self.accessToken = user.token.token
    self.refreshToken = user.token.refreshToken
  }
  
  func saveToken(_ token: Token) {
    self.accessToken = token.token
    self.refreshToken = token.refreshToken
  }
  
  func loadUser() -> User {
    let token = Token(token: accessToken, refreshToken: refreshToken)
    return User(
      id: self.userId,
      email: self.email,
      username: self.username,
      profileImageUrl: self.profileImageUrl,
      token: token
    )
  }
  
  func loadToken() -> Token {
    return Token(token: accessToken, refreshToken: refreshToken)
  }
  
  func clearUser() {
    self.userId = ""
    self.email = ""
    self.username = ""
    self.profileImageUrl = ""
    self.accessToken = ""
    self.refreshToken = ""
  }
}
