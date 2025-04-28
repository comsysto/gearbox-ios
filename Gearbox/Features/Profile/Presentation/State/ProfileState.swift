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
  var errorMessage: String?
}
