//
//  HomeState.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//

struct HomeState: Equatable {
  // MARK: - TRENDING BLOGS
  var isTrendingLoading: Bool = true
  var trendingBlogs: [Blog] = []
  var currentTrendingBlogIndex: Int = 0
  
  var errorMessage: String = ""
}
