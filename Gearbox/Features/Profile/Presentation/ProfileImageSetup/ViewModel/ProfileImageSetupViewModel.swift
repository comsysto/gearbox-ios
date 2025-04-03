//
//  ProfileImageSetupViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 03.04.2025..
//
import SwiftUI
import Dependency

class ProfileImageSetupViewModel: ObservableObject {
  // MARK: - STATE
  @Published var state: ProfileImageSetupState
  
  // MARK: - CONSTRUCTOR
  init(state: ProfileImageSetupState = ProfileImageSetupState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
}
