//
//  User.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation

struct User: Equatable {
  let id: String
  let email: String
  let username: String
  let profileImageUrl: String?
  let token: Token
}
