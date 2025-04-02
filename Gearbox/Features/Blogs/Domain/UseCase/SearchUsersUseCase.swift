//
//  SearchUsersUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 31.03.2025..
//

class SearchUsersUseCase {
  private let authorRepository: AuthorRepositoryType
  
  init(_ authorRepository: AuthorRepositoryType) {
    self.authorRepository = authorRepository
  }
  
  func execute(query: String, nextPage: Bool = false) async -> Result<[Author], BlogError> {
    return await authorRepository.search(query: query, nextPage)
  }
}
