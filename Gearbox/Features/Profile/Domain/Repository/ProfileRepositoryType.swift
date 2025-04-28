//
//  ProfileRepositoryType.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.04.2025.
//
import Foundation

protocol ProfileRepositoryType {
  func getProfileData(userId: String) async -> Result<ProfileData, ProfileError>
  func uploadProfileImage(image: Data) async -> Result<ProfileData, ProfileError>
  //func getBlogsForProfile(userId: String) async -> Result<[],ProfileError>
}
