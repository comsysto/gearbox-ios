//
//  HomeState.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//

struct HomeState: Equatable {
  var isLoading: Bool = false
  var trendingBlogs: [Blog] = []
  var currentTrendingBlogIndex: Int = 0
  
  var errorMessage: String = ""
}
