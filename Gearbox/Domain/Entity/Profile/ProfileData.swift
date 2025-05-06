//
//  ProfileData.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.04.2025.
//

struct ProfileData {
  let id: String
  let username: String
  let profileImageUrl: String?
  let isProfileOwner: Bool
  
  init(
    id: String,
    username: String,
    profileImageUrl: String?,
    isProfileOwner: Bool
  ) {
    self.id = id
    self.username = username
    self.profileImageUrl = profileImageUrl
    self.isProfileOwner = isProfileOwner
  }
}
