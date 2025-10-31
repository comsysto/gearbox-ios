//
//  CommentModel.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 29.10.2025..
//
import Foundation

public struct CommentPageableSecureRequest: Codable {
  public let token: String
  public let blogId: String
  public let page: Int
  public let size: Int
  
  public init(token: String, blogId: String, page: Int, size: Int) {
    self.token = token
    self.blogId = blogId
    self.page = page
    self.size = size
  }
}

public struct NewCommentPageableSecureRequest: Codable {
  public let token: String
  public let blogId: String
  public let userId: String
  public let content: String
  
  public init(token: String, blogId: String, userId: String, content: String) {
    self.token = token
    self.blogId = blogId
    self.userId = userId
    self.content = content
  }
}

public struct CommentResponse: Identifiable, Decodable {
  public let id: String
  public let blogId: String
  public let userId: String
  public let username: String
  public let userProfileImageUrl: String?
  public let content: String
  
  public init(
    id: String,
    blogId: String,
    userId: String,
    username: String,
    userProfileImageUrl: String,
    content: String
  ) {
    self.id = id
    self.blogId = blogId
    self.userId = userId
    self.username = username
    self.userProfileImageUrl = userProfileImageUrl
    self.content = content
  }
}
