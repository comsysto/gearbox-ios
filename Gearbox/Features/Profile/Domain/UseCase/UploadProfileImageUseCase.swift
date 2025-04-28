//
//  UploadProfilePictureUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.04.2025..
//
import Foundation
import SwiftUI

class UploadProfileImageUseCase {
  private let repository: ProfileRepositoryType
  
  init(_ profileRepoisitory: ProfileRepositoryType) {
    self.repository = profileRepoisitory
  }
  
  func execute(_ image: UIImage) async -> Result<ProfileData, ProfileError> {
    guard let imageData = image.compressImage(withHeight: 200) else {
      return .failure(.imageCompressionFailed("error.image-compression"))
    }
    return await repository.uploadProfileImage(image: imageData)
  }
}
