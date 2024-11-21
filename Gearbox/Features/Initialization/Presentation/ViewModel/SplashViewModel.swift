//
//  ConfigViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 24.10.2024..
//
import SwiftUI
import Dependency

class SplashViewModel: ObservableObject {
  // MARK: - PROPERTIES
  @Dependency(\.refreshUserSessionUseCase) private var refreshUserSessionUseCase: RefreshUserSessionUseCase
  
  @Published var firstView: FirstViewOption = .splash
  
  // MARK: - STORAGE
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  @AppStorage("shouldShowOnBoarding") private var isOnboarding = true
  
  // MARK: - FUNCTIONS
  @MainActor
  func setFirstView() {
    if isOnboarding {
      firstView = .onboarding
      return
    }
    
    guard !refreshToken.isEmpty else {
      firstView = .signIn
      return
    }
    
    Task {
      let result = await refreshUserSessionUseCase.execute()
      
      switch result {
        case .success(let user):
          accessToken = user.token.token
          refreshToken = user.token.refreshToken
          firstView = .home
        case .failure:
          firstView = .signIn
      }
    }
  }
}

enum FirstViewOption {
  case onboarding
  case signIn
  case home
  case splash
}
