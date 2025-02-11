//
//  GetLatestBlogsUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 27.01.2025..
//

class GetLatestBlogsUseCase {
  private let blogRepository: BlogRepositoryType
  
  init(_ blogRepository: BlogRepositoryType) {
    self.blogRepository = blogRepository
  }
  
  func execute(nextPage: Bool = false) async -> Result<[Blog], BlogError> {
    return await blogRepository.getLatestBlogs(nextPage)
  }
}
