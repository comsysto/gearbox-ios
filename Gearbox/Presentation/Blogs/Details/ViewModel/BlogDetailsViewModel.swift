//
//  BlogDetailsViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.02.2025..
//
import SwiftUI
import Dependency

@MainActor
class BlogDetailsViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.getBlogCommentsUseCase) private var getBlogCommentsUseCase: GetBlogCommentsUseCase
  @Dependency(\.cacheNewImagesUseCase) private var cacheNewImagesUseCase: CacheNewImagesUseCase
  
  private let pageController: PageController
  
  // MARK: - STATE
  @Published var state: BlogDetailsState
  
  // MARK: - CONSTRUCTOR
  init(state: BlogDetailsState = BlogDetailsState()) {
    self.state = state
    pageController = PageController(pageSize: 6)
  }
  
  // MARK: - FUNCTIONS
  func select(_ blog: Blog) {
    state.blog = blog
    state.commentList.removeAll()
    pageController.reset()
  }
  
  func loadComments(loadMore: Bool = false) {
    if pageController.isLastPage {
      return
    } else if loadMore && !pageController.isLastPage {
      state.isLoadingMore = true
    } else {
      state.isLoadingComments = true
      pageController.reset()
    }
    
    Task {
      if loadMore { pageController.incrementPage() }
      
      let result = await getBlogCommentsUseCase.execute(
        blogId: state.blog!.id,
        page: pageController.currentPage,
        size: pageController.pageSize
      )
      
      switch result {
        case .success(let commentPage):
          pageController.setLastPage(commentPage.isLastPage)
          print("LAST PAGE: \(pageController.isLastPage)")
          
          if commentPage.items.isEmpty {
            state.isLoadingMore = false
          }
          
          for comment in commentPage.items {
            if comment.profileImageUrl != nil {
              await cacheNewImagesUseCase.executeForUrl(comment.profileImageUrl!)
            }
          }
          
          state.commentList.append(contentsOf: commentPage.items)
          state.isLoadingComments = false
          state.isLoadingMore = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoadingComments = false
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
