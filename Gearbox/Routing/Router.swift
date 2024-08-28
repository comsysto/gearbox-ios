//
//  Router.swift
//  Gearbox
//
//  Created by Filip Kisić on 28.07.2024..
//

import Foundation
import SwiftUI

class Router: ObservableObject {
  // MARK: - ALL ROUTES
  enum Route: Hashable {
    case onboarding
    case signIn
    case signUp
    case home
  }
  
  // MARK: - PROPERTIES
  @Published var path = NavigationPath()
  @AppStorage("shouldShowOnBoarding") var isOnboarding = true
  
  // MARK: - VIEW BUILDER
  @ViewBuilder func view(for route: Route) -> some View {
    switch route {
      case .onboarding:
        OnBoardingView(isOnboarding: $isOnboarding)
      case .signIn:
        SignInView()
      case .signUp:
        SignUpView()
      case .home:
        HomeView()
    }
  }
  
  // MARK: - FUNCTIONS
  func navigateTo(_ route: Route) {
    path.append(route)
  }
  
  func navigateBack() {
    path.removeLast()
  }
  
  func popToRoot() {
    path.removeLast(path.count)
  }
}
