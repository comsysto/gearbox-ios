//
//  ExploreViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 15.03.2025..
//
import SwiftUI
import Dependency

class ExploreViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.searchBlogsUseCase) private var searchBlogsUseCase: SearchBlogsUseCase
  @Dependency(\.searchUsersUseCase) private var searchUsersUseCase: SearchUsersUseCase
  
  // MARK: - STATE
  @Published var state: ExploreState
  
  // MARK: - CONSTRUCTOR
  init(state: ExploreState = ExploreState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  func resetState() {
    state.isLoading = false
    
    state.blogResultList = []
    state.blogSearchResult = .initial
    
    state.authorResultList = []
    state.authorSearchResult = .initial
  }
  
  @MainActor
  func searchBlogsOrUsers(_ query: String) {
    switch (state.searchCategory) {
      case .blog:
        searchBlogs(query)
      case .author:
        searchUsers(query)
    }
  }
  
  @MainActor
  private func searchBlogs(_ query: String) {
    state.isLoading = true
    
    Task {
      let result = await searchBlogsUseCase.execute(query: query)
      
      switch result {
        case .success(let blogs):
          state.isLoading = false
          
          if (blogs.isEmpty) {
            state.blogResultList = []
            state.blogSearchResult = .noResult
            return
          }
          
          state.blogResultList = blogs
          state.blogSearchResult = .result
        case .failure(let error):
          setErrorMessage(error)
          state.blogSearchResult = .error
          state.isLoading = false
      }
    }
  }
  
  @MainActor
  private func searchUsers(_ query: String) {
    state.isLoading = true
    
    Task {
      let result = await searchUsersUseCase.execute(query: query)
      
      switch result {
        case .success(let users):
          state.isLoading = false
          
          if (users.isEmpty) {
            state.authorResultList = []
            state.authorSearchResult = .noResult
            return
          }
          
          state.authorResultList = users
          state.authorSearchResult = .result
        case .failure(let error):
          setErrorMessage(error)
          state.authorSearchResult = .error
          state.isLoading = false
      }
    }
  }
  
  private func setErrorMessage(_ error: BlogError) {
    switch error {
      case .serverError(let message):
        state.errorMessage = message
    }
  }
}
