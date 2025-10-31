//
//  CommentRepositoryType.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.10.2025..
//

protocol CommentRepositoryType {
  func getBlogComments(blogId: String, page: Int, size: Int) async -> Result<Paginated<Comment>, BlogError>
}
