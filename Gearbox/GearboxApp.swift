//
//  GearboxApp.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.07.2024..
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct GearboxApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      MasterRouteView {
        SplashView()
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
