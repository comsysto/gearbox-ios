//
//  GetTrendingBlogsUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
class GetTrendingBlogsUseCase {
  private let blogRepository: BlogRepositoryType
  
  init(_ blogRepository: BlogRepositoryType) {
    self.blogRepository = blogRepository
  }
  
  func execute() async -> Result<[Blog], BlogError> {
    return await blogRepository.getTrendingBlogs()
  }
}
