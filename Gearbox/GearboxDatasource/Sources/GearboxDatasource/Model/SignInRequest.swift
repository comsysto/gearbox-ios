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
