//
//  FirstView.swift
//  Gearbox
//
//  Created by Filip Kisić on 20.08.2024..
//

import SwiftUI

struct FirstView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: InitialViewModel
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      switch viewModel.firstView {
        case .onboarding:
          OnBoardingView()
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        case .signIn:
          SignInView()
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        case .home:
          HomeView()
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
        case .splash:
          SplashView()
      }
    }
    .onAppear {
      viewModel.setFirstView()
    }
  }
}

// MARK: - PREVIEW
#Preview {
  var viewModel = InitialViewModel()
  return ZStack {
    FirstView()
  }.environmentObject(viewModel)
}
