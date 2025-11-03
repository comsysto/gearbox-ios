//
//  LatestViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.01.2025..
//
import SwiftUI
import Dependency

@MainActor
class LatestViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.getLatestBlogsUseCase) private var getLatestBlogsUseCase: GetLatestBlogsUseCase
  @Dependency(\.cacheNewImagesUseCase) private var cacheNewImagesUseCase: CacheNewImagesUseCase
  
  private let pageController: PageController
  
  // MARK: - STATE
  @Published var state: LatestState
  
  // MARK: - CONSTRUCTOR
  init(state: LatestState = LatestState()) {
    self.state = state
    pageController = PageController(pageSize: 10)
  }
  
  // MARK: - FUNCTIONS
  func getLatestBlogs(loadMore: Bool = false) {
    if pageController.isLastPage {
      return
    } else if loadMore && !pageController.isLastPage {
      state.isLoadingMore = true
    } else {
      state.isLoading = true
      pageController.reset()
    }
    
    Task {
      if loadMore { pageController.incrementPage() }
      
      let result = await getLatestBlogsUseCase.execute(page: pageController.currentPage, size: pageController.pageSize)
      
      switch result {
        case .success(let blogPage):
          pageController.setLastPage(blogPage.isLastPage)
          
          if blogPage.items.isEmpty {
            state.isLoading = false
            state.isLoadingMore = false
            return
          }
          
          await cacheNewImagesUseCase.executeForBlogs(blogPage.items)
          
          state.latestBlogs.append(contentsOf: blogPage.items)
          state.isLoading = false
          state.isLoadingMore = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoading = false
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
