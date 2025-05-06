//
//  GetBlogsByAuthorIdUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 30.04.2025..
//

class GetBlogsByAuthorIdUseCase {
  private let repository: ProfileRepositoryType
  
  init(_ repository: ProfileRepositoryType) {
    self.repository = repository
  }
  
  func execute(userId: String, page: Int, size: Int) async -> Result<Paginated<Blog>, ProfileError> {
    return await repository.getBlogsForProfile(userId: userId, page: page, size: size)
  }
}
