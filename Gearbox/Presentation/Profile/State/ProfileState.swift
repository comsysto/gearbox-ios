//
//  ProfileImageSetupState.swift
//  Gearbox
//
//  Created by Filip Kisić on 03.04.2025..
//
import Foundation
import SwiftUI

struct ProfileState {
  var profileData: ProfileData?
  var photoPickerImage: UIImage?
  
  var isLoading: Bool = true
  var isLoadingBlogs: Bool = true
  var isLoadingMore: Bool = false
  var isLastPage: Bool = false
  
  var userBlogs: [Blog] = []
  var likedBlogs: [Blog] = []
  
  var errorMessage: String?
}
