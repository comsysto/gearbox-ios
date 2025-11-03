//
//  AuthorResponseToAuthorEntityConverter.swift
//  Gearbox
//
//  Created by Filip Kisić on 31.03.2025..
//
import RemoteDatasource

class AuthorResponseToAuthorEntityConverter: ConverterType {
  typealias Source = UserResponse
  
  typealias Target = Author
  
  func convert(_ response: UserResponse) -> Author {
    return Author(
      id: response.id,
      username: response.username,
      profileImageUrl: response.profileImageUrl
    )
  }
}
