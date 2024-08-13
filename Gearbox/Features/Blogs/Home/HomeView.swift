//
//  HomeView.swift
//  Gearbox
//
//  Created by Filip Kisić on 13.08.2024..
//

import SwiftUI

struct HomeView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var userViewModel: UserViewModel
  
  // MARK: - BODY
  var body: some View {
    VStack {
      Text("Hello, \(userViewModel.currentUser?.username ?? "No username")")
    }
  }
}

// MARK: - PREVIEW
#Preview {
  HomeView()
}
