//
//  UserViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency

class UserViewModel: ObservableObject {
  // MARK: - DEPENDECIES
  @Dependency(\.signInUseCase) private var signInUseCase
  @Dependency(\.signUpUseCase) private var signUpUseCase
  
  // MARK: - STATE
  @Published var authenticationState = AuthenticationState.unauthenticated(nil)
  
  // MARK: - FUNCTIONS
  @MainActor
  func signIn(email: String, password: String) async {
    authenticationState = .loading
    let result = await signInUseCase.execute(email: email, password: password)
    switch result {
      case .success(let user):
        authenticationState = .authenticated(user)
      case .failure(let error):
        authenticationState = .unauthenticated(error)
    }
  }
}

enum AuthenticationState {
  case loading
  case authenticated(User)
  case unauthenticated(Error?)
}
