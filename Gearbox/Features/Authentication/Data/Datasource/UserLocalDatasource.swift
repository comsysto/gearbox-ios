//
//  UserLocalStorage.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.08.2024..
//

import Foundation
import SwiftUI

class UserLocalDatasource {
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  
  func cacheToken(_ token: Token) {
    self.accessToken = token.token
    self.refreshToken = token.refreshToken
  }
  
  func loadToken() -> Token {
    return Token(token: accessToken, refreshToken: refreshToken)
  }
  
  func clearCache() {
    self.accessToken = ""
    self.refreshToken = ""
  }
}
