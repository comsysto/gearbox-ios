//
//  LatestState.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.01.2025..
//

struct LatestState: Equatable {
  var isLoading: Bool = true
  var isLoadingMore: Bool = false

  var latestBlogs: [Blog] = []
  
  var errorMessage: String = ""
}
