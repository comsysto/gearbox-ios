//
//  UserRequestToEntityMapper.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation
import RemoteDatasource

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
        accessToken: source.token,
        refreshToken: source.refreshToken
      )
    )
  }
}
