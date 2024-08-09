//
//  File.swift
//  
//
//  Created by Filip Kisić on 01.08.2024..
//

import Foundation

public struct SignUpRequest: Codable{
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
