//
//  MasterView.swift
//  Gearbox
//
//  Created by Filip Kisić on 28.07.2024..
//

import SwiftUI

struct MasterRouteView<Content: View>: View {
  // MARK: - PROPERTIES
  @StateObject var router = Router()
  
  @StateObject var initialViewModel = SplashViewModel()
  @StateObject var signInViewModel = SignInViewModel()
  @StateObject var signUpViewModel = SignUpViewModel()
  @StateObject var homeViewModel = HomeViewModel()
  
  private let content: Content
  
  // MARK: - INITIALIZER
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  // MARK: - BODY
  var body: some View {
    NavigationStack(path: $router.path) {
      content.navigationDestination(for: Router.Route.self) { route in
        router.view(for: route)
      }
    } //: NAVIGATION STACK
    .environmentObject(router)
    .environmentObject(initialViewModel)
    .environmentObject(signInViewModel)
    .environmentObject(signUpViewModel)
    .environmentObject(homeViewModel)
  }
}
