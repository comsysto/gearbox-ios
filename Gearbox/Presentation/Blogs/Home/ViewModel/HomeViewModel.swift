//
//  HomeViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
import SwiftUI
import Dependency

class HomeViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.getTrendingBlogsUseCase) private var getTrendingBlogsUseCase: GetTrendingBlogsUseCase
  @Dependency(\.cacheNewImagesUseCase) private var cacheNewImagesUseCase: CacheNewImagesUseCase
  
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  // MARK: - STATE
  @Published var state: HomeState
  
  // MARK: - CONSTRUCTOR
  init(state: HomeState = HomeState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  @MainActor
  func getTrendingBlogs() {
    state.isTrendingLoading = true
    
    Task {
      let result = await getTrendingBlogsUseCase.execute()
      
      switch result {
        case .success(let blogs):
          await cacheNewImagesUseCase.execute(for: blogs)
          
          state.trendingBlogs = blogs
          state.isTrendingLoading = false
        case .failure(let error):
          setErrorMessage(error)
          state.isTrendingLoading = false
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
