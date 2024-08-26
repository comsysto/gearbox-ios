//
//  FirstView.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.08.2024..
//

import SwiftUI

struct FirstView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: UserViewModel
  
  @AppStorage("shouldShowOnBoarding") private var isOnboarding = true
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      switch viewModel.firstScreen {
        case .onboarding:
          OnBoardingView(isOnboarding: $isOnboarding)
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        case .signIn:
          SignInView()
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        case .home:
          HomeView()
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        default:
          SplashView()
      }
    }
    .task {
      await viewModel.setFirstScreen()
    }
  }
}

// MARK: - PREVIEW
#Preview {
  var viewModel = UserViewModel()
  return ZStack {
    FirstView()
  }.environmentObject(viewModel)
}
