//
//  SearchBlogsUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 25.03.2025..
//

class SearchBlogsUseCase {
  private let blogRepository: BlogRepositoryType
  
  init(_ blogRepository: BlogRepositoryType) {
    self.blogRepository = blogRepository
  }
  
  func execute(query: String, nextPage: Bool = false) async -> Result<[Blog], BlogError> {
    return await blogRepository.searchBlogs(query: query, nextPage)
  }
}
