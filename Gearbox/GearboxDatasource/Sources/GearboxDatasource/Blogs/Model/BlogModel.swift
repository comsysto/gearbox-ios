//
//  BlogResponse.swift
//  GearboxDatasource
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation

public struct BlogPageableSecureRequest: Codable {
  public let token: String
  public let page: Int
  public let size: Int
  
  public init(token: String, page: Int, size: Int) {
    self.token = token
    self.page = page
    self.size = size
  }
}

public struct BlogResponse: Identifiable, Decodable {
  public let id: String
  public let title: String
  public let content: String
  public let thumbnailImageUrl: String
  public let createDate: Date
  public let numberOfLikes: Int
  public let category: String
  public let author: UserResponse
  
  public init(
    id: String,
    title: String,
    content: String,
    thumbnailImageUrl: String,
    createDate: Date,
    numberOfLikes: Int,
    category: String,
    author: UserResponse
  ) {
    self.id = id
    self.title = title
    self.content = content
    self.thumbnailImageUrl = thumbnailImageUrl
    self.createDate = createDate
    self.numberOfLikes = numberOfLikes
    self.category = category
    self.author = author
  }
}

public struct UserResponse: Identifiable, Decodable {
  public let id: String
  public let username: String
  public let profileImageUrl: String?
  
  public init(id: String, username: String, profileImageUrl: String?) {
    self.id = id
    self.username = username
    self.profileImageUrl = profileImageUrl
  }
}
