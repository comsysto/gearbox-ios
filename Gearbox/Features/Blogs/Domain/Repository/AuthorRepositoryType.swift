//
//  UserRepositoryType.swift
//  Gearbox
//
//  Created by Filip Kisić on 31.03.2025..
//

protocol AuthorRepositoryType {
  func search(query: String, _ nextPage: Bool) async -> Result<[Author], BlogError>
}
