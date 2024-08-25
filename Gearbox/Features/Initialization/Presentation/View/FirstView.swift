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
        case .signIn:
          SignInView()
        case .home:
          HomeView()
      }
    }
    .task {
      await viewModel.setFirstScreen()
    }
  }
}

// MARK: - PREVIEW
#Preview {
  FirstView()
}
