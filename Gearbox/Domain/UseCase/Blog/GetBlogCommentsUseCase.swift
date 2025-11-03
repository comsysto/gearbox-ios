//
//  GetBlogCommentsUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 30.10.2025..
//

class GetBlogCommentsUseCase {
  private let commentRepository: CommentRepositoryType
  
  init(_ commentRepository: CommentRepositoryType) {
    self.commentRepository = commentRepository
  }
  
  func execute(blogId: String, page: Int, size: Int) async -> Result<Paginated<Comment>, BlogError> {
    return await commentRepository.getBlogComments(blogId: blogId, page: page, size: size)
  }
}
