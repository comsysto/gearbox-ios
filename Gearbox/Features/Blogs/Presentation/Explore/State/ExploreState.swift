//
//  ExploreState.swift
//  Gearbox
//
//  Created by Filip Kisić on 15.03.2025..
//

struct ExploreState: Equatable {
  var searchTerm: String = ""
  var searchCategory: SearchCateogory = .blog
  
  var blogSearchResult: ExploreSearchResult = .initial
  var blogResultList: [Blog] = []
  
  var authorSearchResult: ExploreSearchResult = .initial
  var authorResultList: [Author] = []
  
  var isLoading: Bool = true
  var isLoadingMore: Bool = false
  var isLastPage: Bool = false
  
  var errorMessage: String = ""
}

enum SearchCateogory {
  case author, blog
}

enum ExploreSearchResult {
  case initial, result, noResult, error
}
