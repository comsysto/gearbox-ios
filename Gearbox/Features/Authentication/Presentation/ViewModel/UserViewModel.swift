//
//  UserViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency
import SwiftUI

class UserViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.signInUseCase) private var signInUseCase: SignInUseCase
  @Dependency(\.signUpUseCase) private var signUpUseCase: SignUpUseCase
  @Dependency(\.refreshUserSessionUseCase) private var refreshUserSessionUseCase: RefreshUserSessionUseCase
  
  // MARK: - STORAGE
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  @AppStorage("shouldShowOnBoarding") private var isOnboarding = true
  
  // MARK: - STATE
  @Published var authenticationState = AuthenticationState.unauthenticated(nil)
  @Published var currentUser: User? = nil
  @Published var firstScreen: FirstScreenOptions = .onboarding
  
  // MARK: - FUNCTIONS
  @MainActor
  func signIn(email: String, password: String) async {
    authenticationState = .loading
    
    let result = await signInUseCase.execute(email: email, password: password)
    switch result {
      case .success(let user):
        setAuthenticatedState(user)
      case .failure(let error):
        authenticationState = .unauthenticated(error)
    }
  }
  
  @MainActor
  func signUp(email: String, username: String, password: String, confirmPassword: String) async {
    authenticationState = .loading
    
    let result = await signUpUseCase.execute(
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword
    )
    switch result {
      case .success(let user):
        setAuthenticatedState(user)
      case .failure(let error):
        authenticationState = .unauthenticated(error)
    }
  }
  
  @MainActor
  func setFirstScreen() async {
    if (isOnboarding) {
      firstScreen = .onboarding
    }
    
    guard !refreshToken.isEmpty else {
      firstScreen = .signIn
      return
    }
    
    let result = await refreshUserSessionUseCase.execute()
    switch result {
      case .success(let user):
        firstScreen = .home
        currentUser = user
      case .failure(_):
        firstScreen = .signIn
    }
  }
  
  
  private func setAuthenticatedState(_ user: User) {
    authenticationState = .authenticated(user)
    currentUser = user
  }
}

enum AuthenticationState: Equatable {
  case loading
  case authenticated(User)
  case unauthenticated(AuthError?)
  
  static func == (lhs: AuthenticationState, rhs: AuthenticationState) -> Bool {
    switch (lhs, rhs) {
      case (.loading, .loading):
        return true
      case (.authenticated(let lhsUser), .authenticated(let rhsUser)):
        return lhsUser == rhsUser
      case (.unauthenticated(let lhsError), .unauthenticated(let rhsError)):
        return lhsError == rhsError
      default:
        return false
    }
  }
}

enum FirstScreenOptions {
  case onboarding
  case signIn
  case home
}
