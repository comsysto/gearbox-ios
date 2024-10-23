//
//  SignUpViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.10.2024..
//
import SwiftUI
import Dependency

class SignUpViewModel: ObservableObject {
  // MARK: - DEPENDENCIES
  @Dependency(\.signUpUseCase) private var signUpUseCase: SignUpUseCase
  
  // MARK: - CACHE STORAGE
  @KeychainStorage("accessToken") private var accessToken: String
  @KeychainStorage("refreshToken") private var refreshToken: String
  
  // MARK: - STATE
  @Published var state: SignUpState
  
  // MARK: - CONSTRUCTOR
  init(state: SignUpState = SignUpState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  @MainActor
  func signUp() {
    state.isLoading = true
    
    if !isInputValid() {
      state.isLoading = false
      return
    }
    
    Task {
      let result = await signUpUseCase.execute(
        email: state.email,
        username: state.username,
        password: state.password,
        confirmPassword: state.confirmPassword
      )
      
      switch result {
        case .success(let user):
          state.isLoading = false
          resetValidationState()
          
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
  
  private func isInputValid() -> Bool {
    state.emailValidationMessage = FormValidator.validate(state.email, for: .email)
    state.usernameValidationMessage = FormValidator.validate(state.username, for: .empty)
    state.passwordValidationMessage = FormValidator.validate(state.password, for: .passwordObeyPolicy)
    state.confirmPasswordValidationMessage = FormValidator.validate(
      state.confirmPassword,
      for: .passwordsMatch,
      with: state.password
    )
    state.confirmPasswordValidationMessage = FormValidator.validate(state.confirmPassword, for: .passwordObeyPolicy)
    
    return state.emailValidationMessage == nil &&
    state.usernameValidationMessage == nil &&
    state.passwordValidationMessage == nil &&
    state.confirmPasswordValidationMessage == nil
  }
  
  private func resetValidationState() {
    state.emailValidationMessage = nil
    state.usernameValidationMessage = nil
    state.passwordValidationMessage = nil
    state.confirmPasswordValidationMessage = nil
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
}
