//
//  GetProfileDataUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 26.04.2025..
//

class GetProfileDataUseCase {
  private let profileRepostiory: ProfileRepositoryType
  
  init(_ profileRepostiory: ProfileRepositoryType) {
    self.profileRepostiory = profileRepostiory
  }
  
  func execute(userId: String) async -> Result<ProfileData, ProfileError> {
    return await profileRepostiory.getProfileData(userId: userId)
  }
}
