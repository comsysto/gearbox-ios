//
//  ProfileBlogFilter.swift
//  Gearbox
//
//  Created by Filip Kisić on 19.05.2025..
//

enum BlogFilterSelection: Int, CaseIterable, Hashable {
  case postedBlogs
  case likedBlogs
  
  var title: String {
    switch self {
      case .postedBlogs: return "profile.label.posted-blogs"
      case .likedBlogs: return "profile.label.liked-blogs"
    }
  }
}
