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
  @Published var currentUser: User? = nil
  
  // MARK: - FUNCTIONS
  @MainActor
  func signIn(email: String, password: String) async {
    authenticationState = .loading
    let result = await signInUseCase.execute(email: email, password: password)
    switch result {
      case .success(let user):
        authenticationState = .authenticated(user)
        currentUser = user
        print("SET USER \(user.username)")
      case .failure(let error):
        authenticationState = .unauthenticated(error)
        print("ERROR??????")
    }
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
