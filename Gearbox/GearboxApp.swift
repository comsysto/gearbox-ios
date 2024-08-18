//
//  GearboxApp.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.07.2024..
//

import SwiftUI

@main
struct GearboxApp: App {
  // MARK: - PROPERTIES
  @AppStorage("shouldShowOnBoarding") private var isOnboarding = true
  @KeychainStorage("accessToken") private var accessToken: String?
  
  // MARK: - BODY
  var body: some Scene {
    WindowGroup {
      MasterRouteView {
        if isOnboarding {
          OnBoardingView(isOnboarding: $isOnboarding)
        } else {
          SignInView()
        }
      }
    }
  }
}

// ALL AVAILABLE FONTS
// RobotoCondensed-Regular
// RobotoCondensed-Thin
// RobotoCondensed-ExtraLight
// RobotoCondensed-Light
// RobotoCondensed-Medium
// RobotoCondensed-SemiBold
// RobotoCondensed-Bold
// RobotoCondensed-ExtraBold
// RobotoCondensed-Black
