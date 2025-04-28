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
  let postedBlogs: [Blog]
  let likedBlogs: [Blog]
  
  init(
    id: String,
    username: String,
    profileImageUrl: String?,
    isProfileOwner: Bool,
    postedBlogs: [Blog] = [],
    likedBlogs: [Blog] = []
  ) {
    self.id = id
    self.username = username
    self.profileImageUrl = profileImageUrl
    self.isProfileOwner = isProfileOwner
    self.postedBlogs = postedBlogs
    self.likedBlogs = likedBlogs
  }
}
