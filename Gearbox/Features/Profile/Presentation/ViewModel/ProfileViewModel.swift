//
//  ProfileImageSetupViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 03.04.2025..
//
import SwiftUI
import PhotosUI
import Dependency

//TODO: CONSIDER PLACING EXPLORE - SEARCH USERS USE CASE IN PROFILE FEATURE BECAUSE THEN THERE IS SINGLE REPOSITORY, MODEL, MAPPER, ETC.

class ProfileViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.uploadProfileImageUseCase) private var uploadProfileImageUseCase: UploadProfileImageUseCase
  
  // MARK: - STATE
  @Published var state: ProfileState
  @Published var selectedImage: PhotosPickerItem?
  
  // MARK: - CONSTRUCTOR
  init(state: ProfileState = ProfileState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  func chooseImage() {
    Task {
      do {
        guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else {
          state.errorMessage = "Failed to load image data."
          return
        }
        DispatchQueue.main.async {
          self.state.profileImage = UIImage(data: imageData)
        }
      } catch {
        state.errorMessage = "Failed to compute selected image."
      }
    }
  }
  
  func uploadImage() {
    state.isLoading = true
    Task {
      let result = await uploadProfileImageUseCase.execute(state.profileImage!)
      
      switch result {
        case .success(let profileData):
          state.isLoading = false
          
          //TODO: Find out what with profileImageUrl from profileData...
          //state.profileImage = profileData.
          break
        case .failure(let error):
          state.isLoading = false
          state.errorMessage = error.message
      }
    }
  }
}
