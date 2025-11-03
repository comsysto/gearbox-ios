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
  
  func execute(page: Int, size: Int) async -> Result<Paginated<Blog>, BlogError> {
    return await blogRepository.getLatestBlogs(page: page, size: size)
  }
}
