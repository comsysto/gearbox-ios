//
//  LatestViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.01.2025..
//
import SwiftUI
import Dependency

class LatestViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.getLatestBlogsUseCase) private var getLatestBlogsUseCase: GetLatestBlogsUseCase
  @Dependency(\.cacheNewImagesUseCase) private var cacheNewImagesUseCase: CacheNewImagesUseCase
  
  // MARK: - STATE
  @Published var state: LatestState
  
  // MARK: - CONSTRUCTOR
  init(state: LatestState = LatestState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  @MainActor
  func getLatestBlogs() {
    state.isLoading = true
    
    Task {
      let result = await getLatestBlogsUseCase.execute()
      
      switch result {
        case .success(let blogs):
          await cacheNewImagesUseCase.execute(for: blogs)
          
          state.latestBlogs = blogs
          state.isLoading = false
          state.isLastPage = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoading = false
      }
    }
  }
  
  @MainActor
  func getNextPage() {
    guard !state.isLoadingMore && !state.isLastPage else { return }
    
    state.isLoadingMore = true
    
    Task {
      let result = await getLatestBlogsUseCase.execute(nextPage: true)
      
      switch result {
        case .success(let blogs):
          guard !blogs.isEmpty else {
            state.isLoadingMore = false
            state.isLastPage = true
            return
          }
          
          await cacheNewImagesUseCase.execute(for: blogs)
          
          state.latestBlogs.append(contentsOf: blogs)
          state.isLoadingMore = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoadingMore = false
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
