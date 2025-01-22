//
//  UserRequestToEntityMapper.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation
import GearboxDatasource

class AuthenticationResponseToUserEntityConverter: ConverterType {
  typealias Source = AuthenticationResponse
  typealias Target = User
  
  func convert(_ source: AuthenticationResponse) -> User {
    return User(
      id: source.id,
      email: source.email,
      username: source.username,
      profileImageUrl: source.profileImageUrl,
      token: Token(
        token: source.token,
        refreshToken: source.refreshToken
      )
    )
  }
}
