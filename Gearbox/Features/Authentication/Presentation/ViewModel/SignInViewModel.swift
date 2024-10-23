//
//  SignInViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.10.2024..
//
import SwiftUI
import Dependency

class SignInViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.signInUseCase) private var signInUseCase: SignInUseCase
  
  // MARK: - CACHE STORAGE
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  
  // MARK: - STATE
  @Published var state: SignInState
  
  // MARK: - CONSTRUCTOR
  init(state: SignInState = SignInState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  @MainActor
  func signIn() {
    state.isLoading = true
    
    state.emailValidationMessage = state.email.validateAsEmail()
    state.passwordValidationMessage = state.password.validateAsPassword()
    
    if !isInputValid() {
      state.isLoading = false
      return
    }
    
    Task {
      let result = await signInUseCase.execute(email: state.email, password: state.password)
      
      switch result {
        case .success(let user):
          state.isLoading = false
          state.emailValidationMessage = nil
          state.passwordValidationMessage = nil
          
          accessToken = user.token.token
          refreshToken = user.token.refreshToken
          
          state.authState = .authenticated
        case .failure(let error):
          state.isLoading = false
          
          setErrorMessage(error)
          state.isErrorShown = true
          
          state.authState = .unauthenticated
      }
    }
  }
  
  private func setErrorMessage(_ error: AuthError?) {
    switch error {
      case .invalidRequest(let message),
          .userNotFound(let message),
          .userAlreadyExists(let message),
          .expiredToken(let message),
          .serverError(let message):
        state.errorMessage = message
      default:
        state.errorMessage = "error.unknown"
    }
  }
  
  private func isInputValid() -> Bool {
    return state.emailValidationMessage == nil && state.passwordValidationMessage == nil
  }
}
