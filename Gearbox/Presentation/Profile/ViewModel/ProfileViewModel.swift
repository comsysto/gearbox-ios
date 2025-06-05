//
//  ProfileImageSetupViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 03.04.2025..
//
import SwiftUI
import PhotosUI
import Dependency

@MainActor
class ProfileViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.uploadProfileImageUseCase) private var uploadProfileImageUseCase: UploadProfileImageUseCase
  @Dependency(\.getProfileDataUseCase) private var getProfileDataUseCase: GetProfileDataUseCase
  @Dependency(\.getBlogsByAuthorIdUseCase) private var getBlogsByAuthorIdUseCase: GetBlogsByAuthorIdUseCase
  @Dependency(\.cacheNewImagesUseCase) private var cacheNewImagesUseCase: CacheNewImagesUseCase
  
  // MARK: - STATE
  @Published var state: ProfileState
  @Published var selectedImage: PhotosPickerItem?
  
  private let pageController: PageController
  
  // MARK: - CONSTRUCTOR
  init(state: ProfileState = ProfileState()) {
    self.state = state
    self.pageController = PageController()
  }
  
  // MARK: - FUNCTIONS
  func loadUserData(for userId: String?) {
    state.isLoading = true
    
    Task {
      let result = await getProfileDataUseCase.execute(for: userId)
      
      switch result {
        case .success(let profileData):
          state.profileData = profileData
          state.isLoading = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoading = false
      }
    }
  }
  
  func loadUserBlogs(for userId: String?, loadMore: Bool = false) {
    if loadMore {
      state.isLoadingMore = true
    } else {
      state.isLoadingBlogs = true
      pageController.reset()
      state.userBlogs = []
    }
    
    Task {
      if loadMore { pageController.incrementPage() }
      let result = await getBlogsByAuthorIdUseCase.execute(userId: userId, page: pageController.currentPage, size: pageController.pageSize)
      
      switch result {
        case .success(let blogPage):
          pageController.setLastPage(blogPage.isLastPage)
          
          if blogPage.items.isEmpty {
            state.isLoadingBlogs = false
            state.isLoadingMore = false
            return
          }
          
          await cacheNewImagesUseCase.execute(for: blogPage.items)
          
          state.userBlogs.append(contentsOf: blogPage.items)
          state.isLoadingBlogs = false
          state.isLoadingMore = false
        case .failure(let error):
          setErrorMessage(error)
          state.isLoadingBlogs = false
          state.isLoadingMore = false
      }
    }
  }
  
  func loadLikedBlogs() {
    
  }
  
  func chooseImage() {
    Task {
      do {
        guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else {
          state.errorMessage = "Failed to load image data."
          return
        }
        DispatchQueue.main.async { //TODO: Check if this could be removed since whole class is annotated with @MainActor
          self.state.photoPickerImage = UIImage(data: imageData)
        }
      } catch {
        state.errorMessage = "Failed to process selected image."
      }
    }
  }
  
  func uploadImage() {
    guard let image = state.photoPickerImage else {
      state.errorMessage = "No image selected."
      return
    }
    
    state.isLoading = true
    Task {
      let result = await uploadProfileImageUseCase.execute(image)
      
      switch result {
        case .success(let profileData):
          state.profileData = profileData
          state.isLoading = false
          break
        case .failure(let error):
          state.isLoading = false
          state.errorMessage = error.message
      }
    }
  }
  
  private func setErrorMessage(_ error: ProfileError) {
    switch error {
      case .serverError(let message), .imageCompressionFailed(let message), .blogsNotFound(let message):
        state.errorMessage = message
    }
  }
}
