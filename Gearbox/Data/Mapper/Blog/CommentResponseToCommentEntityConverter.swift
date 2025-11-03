//
//  CommentResponseToCommentEntityConverter.swift
//  Gearbox
//
//  Created by Filip Kisić on 30.10.2025..
//
import RemoteDatasource

class CommentResponseToCommentEntityConverter: ConverterType {
  typealias Source = CommentResponse
  typealias Target = Comment
  
  func convert(_ response: CommentResponse) -> Comment {
    return Comment(
      id: response.id,
      blogId: response.blogId,
      userId: response.userId,
      username: response.username,
      profileImageUrl: response.userProfileImageUrl,
      content: response.content,
    )
  }
}
