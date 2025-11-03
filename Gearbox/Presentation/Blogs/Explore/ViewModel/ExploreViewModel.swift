//
//  ExploreViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 15.03.2025..
//
import SwiftUI
import Dependency

@MainActor
class ExploreViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.searchBlogsUseCase) private var searchBlogsUseCase: SearchBlogsUseCase
  @Dependency(\.searchUsersUseCase) private var searchUsersUseCase: SearchUsersUseCase
  
  // MARK: - STATE
  @Published var state: ExploreState
  
  private let pageController: PageController
  
  // MARK: - CONSTRUCTOR
  init(state: ExploreState = ExploreState()) {
    self.state = state
    self.pageController = PageController(pageSize: 7)
  }
  
  // MARK: - FUNCTIONS
  func resetState() {
    state.isLoading = false
    pageController.reset()
    
    state.blogResultList = []
    state.blogSearchResult = .initial
    
    state.authorResultList = []
    state.authorSearchResult = .initial
  }
  
  func searchBlogsOrUsers(loadMore: Bool = false) {
    switch (state.searchCategory) {
      case .blog:
        if loadMore { searchMoreBlogs() } else { searchBlogs() }
      case .author:
        if loadMore { searchMoreUsers() } else { searchUsers() }
    }
  }
  
  private func searchBlogs() {
    state.isLoading = true
    
    pageController.reset()
    
    Task {
      let result = await searchBlogsUseCase.execute(query: state.searchTerm, page: pageController.currentPage, size: pageController.pageSize)
      
      switch result {
        case .success(let blogPage):
          state.isLastPage = blogPage.isLastPage
          
          if blogPage.items.isEmpty {
            state.blogResultList = []
            state.blogSearchResult = .noResult
            state.isLoading = false
            return
          }
          
          state.blogResultList = blogPage.items
          state.blogSearchResult = .result
          state.isLoading = false
        case .failure(let error):
          setErrorMessage(error)
          state.blogSearchResult = .error
          state.isLoading = false
      }
    }
  }
  
  private func searchMoreBlogs() {
    if state.isLastPage { return }
    
    state.isLoadingMore = true
    
    pageController.incrementPage()
    
    Task {
      let result = await searchBlogsUseCase.execute(query: state.searchTerm, page: pageController.currentPage, size: pageController.pageSize)
      
      switch result {
        case .success(let blogPage):
          state.isLastPage = blogPage.isLastPage
          
          if blogPage.items.isEmpty {
            state.isLoadingMore = false
            return
          }
          
          state.blogResultList.append(contentsOf: blogPage.items)
          state.isLoadingMore = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoadingMore = false
      }
    }
  }
  
  private func searchUsers() {
    state.isLoading = true
    
    Task {
      let result = await searchUsersUseCase.execute(query: state.searchTerm, page: pageController.currentPage, size: pageController.pageSize)
      
      switch result {
        case .success(let usersPage):
          state.isLastPage = usersPage.isLastPage
          
          if usersPage.items.isEmpty {
            state.authorResultList = []
            state.authorSearchResult = .noResult
            state.isLoading = false
            return
          }
          
          state.authorResultList = usersPage.items
          state.authorSearchResult = .result
          state.isLoading = false
        case .failure(let error):
          setErrorMessage(error)
          state.authorSearchResult = .error
          state.isLoading = false
      }
    }
  }
  
  private func searchMoreUsers() {
    if state.isLastPage { return }
    
    state.isLoadingMore = true
    
    pageController.incrementPage()
    
    Task {
      let result = await searchUsersUseCase.execute(query: state.searchTerm, page: pageController.currentPage, size: pageController.pageSize)
      
      switch result {
        case .success(let usersPage):
          state.isLastPage = usersPage.isLastPage
          
          if usersPage.items.isEmpty {
            state.isLoadingMore = false
            return
          }
          
          state.authorResultList.append(contentsOf: usersPage.items)
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
