//
//  RefreshTokenModelToTokenEntityConverter.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.08.2024..
//

import Foundation
import GearboxDatasource

class RefreshTokenResponseToTokenEntityConverter: Converter {
  typealias Source = RefreshTokenResponse
  typealias Target = Token
  
  func convert(_ source: RefreshTokenResponse) -> Token {
    return Token(token: source.token, refreshToken: source.refreshToken)
  }
}
