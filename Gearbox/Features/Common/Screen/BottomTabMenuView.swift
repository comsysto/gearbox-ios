//
//  BottomTabMenuView.swift
//  Gearbox
//
//  Created by Filip Kisić on 28.08.2024..
//

import SwiftUI

struct BottomTabMenuView: View {
  // MARK: - BODY
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Label("label.home", systemImage: "newspaper")
        }
      ExploreView()
        .tabItem {
          Label("label.explore", systemImage: "magnifyingglass")
        }
      CreateNewView()
        .tabItem {
          Label("label.create", systemImage: "plus.square")
        }
      BookmarkedBlogsView()
        .tabItem {
          Label("label.bookmarks", systemImage: "bookmark")
        }
      ProfileView()
        .tabItem {
          Label("label.garage", systemImage: "gear")
        }
    }
    .navigationBarBackButtonHidden()
  }
}

// MARK: - PREVIEW
#Preview {
  BottomTabMenuView()
}
