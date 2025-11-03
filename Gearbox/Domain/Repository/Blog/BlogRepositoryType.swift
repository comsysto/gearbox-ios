//
//  BlogRepositoryType.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//

protocol BlogRepositoryType {
  func getTrendingBlogs() async -> Result<[Blog], BlogError>
  func getLatestBlogs(page: Int, size: Int) async -> Result<Paginated<Blog>, BlogError>
  func searchBlogs(query: String, page: Int, size: Int) async -> Result<Paginated<Blog>, BlogError>
}
