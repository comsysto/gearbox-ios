//
//  UserResponseProfileDataMapper.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.04.2025..
//
import RemoteDatasource

class UserResponseToProfileDataConverter: ConverterType {
  typealias Source = UserResponse
  typealias Target = ProfileData
  
  func convert(_ response: UserResponse) -> ProfileData {
    return ProfileData(
      id: response.id,
      username: response.username,
      profileImageUrl: response.profileImageUrl,
      isProfileOwner: response.isProfileOwner
    )
  }
}
