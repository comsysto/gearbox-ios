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
          await downloadImages(for: blogs)
          state.trendingBlogs = blogs
          state.isTrendingLoading = false
        case .failure(let error):
          setErrorMessage(error)
          state.isTrendingLoading = false
      }
    }
  }
  
  private func downloadImages(for blogs: [Blog]) async {
    for blog in blogs {
      guard let url = URL(string: blog.thumbnailImageUrl) else { return }
      
      if self.imageCache.load(forKey: blog.thumbnailImageUrl) == nil {
        do {
          let (data, _) = try await URLSession.shared.data(from: url)
          if let image = UIImage(data: data) {
            self.imageCache.save(image, forKey: blog.thumbnailImageUrl)
          }
        } catch {
          let image = UIImage(named: "photo_icon")!
          self.imageCache.save(image, forKey: blog.thumbnailImageUrl)
        }
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
