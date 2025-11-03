//
//  UserRepositoryType.swift
//  Gearbox
//
//  Created by Filip Kisić on 31.03.2025..
//

protocol AuthorRepositoryType {
  func search(query: String, page: Int, size: Int) async -> Result<Paginated<Author>, BlogError>
}
