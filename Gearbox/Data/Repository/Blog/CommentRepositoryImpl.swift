//
//  CommentRepositoryImpl.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.10.2025..
//
import Foundation
import RemoteDatasource

class CommentRepositoryImpl: CommentRepositoryType {
  private let blogApi: BlogDatasourceType
  private let userSessionRepository: UserSessionRepositoryType
  private let commentResponseToCommentEntityConverter: CommentResponseToCommentEntityConverter
  
  init(_ blogApi: BlogDatasourceType, _ userSessionRepository: UserSessionRepositoryType, _ commentResponseToCommentEntityConverter: CommentResponseToCommentEntityConverter) {
    self.blogApi = blogApi
    self.userSessionRepository = userSessionRepository
    self.commentResponseToCommentEntityConverter = commentResponseToCommentEntityConverter
  }
  
  func getBlogComments(blogId: String, page: Int, size: Int) async -> Result<Paginated<Comment>, BlogError> {
    do {
      let token = userSessionRepository.getSession().token
      let request = CommentPageableSecureRequest(
        token: token.accessToken,
        blogId: blogId,
        page: page,
        size: size
      )
      
      let response = try await blogApi.getBlogComments(request)
      
      let comments = response.content.map(commentResponseToCommentEntityConverter.convert)
      let paginated = Paginated(items: comments, isLastPage: response.last)
      return .success(paginated)
    } catch {
      switch error as? BlogError {
        case .serverError(let message):
          return .failure(.serverError(message))
        default:
          return .failure(.serverError("error.unknown"))
      }
    }
  }
}
