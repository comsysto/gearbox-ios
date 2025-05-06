//
//  ProfileImageSetupState.swift
//  Gearbox
//
//  Created by Filip Kisić on 03.04.2025..
//
import Foundation
import SwiftUI

struct ProfileState {
  var profileImage: UIImage?
  var isGuest: Bool = false
  
  var isLoading: Bool = false
  var isLoadingBlogs: Bool = false
  var isLoadingMore: Bool = false
  var isLastPage: Bool = false
  
  var userBlogs: [Blog] = []
  var likedBlogs: [Blog] = []
  
  var errorMessage: String?
}
