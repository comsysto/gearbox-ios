//
//  BlogRepositoryType.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//

protocol BlogRepositoryType {
  func getTrendingBlogs() async -> Result<[Blog], BlogError>
}
