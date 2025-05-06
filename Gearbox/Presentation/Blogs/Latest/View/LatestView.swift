//
//  LatestView.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.01.2025..
//

import SwiftUI

struct LatestView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: LatestViewModel
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack {
        ScrollView {
          LazyVStack {
            renderLatestBlogs()
            
            if viewModel.state.isLoadingMore {
              ProgressView()
                .padding()
            }
          } //: LAZY VSTACK
        } //: SCROLL VIEW
      } //: VSTACK
      .navigationTitle("label.latest")
      .navigationBarTitleDisplayMode(.inline)
    } //: ZSTACK
  }
}

// MARK: - VIEW EXTENSIONS
private extension LatestView {
  @ViewBuilder
  func renderLatestBlogs() -> some View {
    if viewModel.state.isLoading {
      ProgressView()
        .padding()
    } else {
      ForEach(0..<viewModel.state.latestBlogs.count, id: \.self) { index in
        renderBlogCard(at: index)
      } //: FOR EACH
    }
  }
  
  @ViewBuilder
  func renderBlogCard(at index: Int) -> some View {
    let blog = viewModel.state.latestBlogs[index]
    BlogCard(for: blog)
    .padding(.horizontal, 20)
    .onAppear {
      if index == viewModel.state.latestBlogs.count - 1 {
        viewModel.getLatestBlogs(loadMore: true)
      }
    }
  }
}

// MARK: - PREVIEW
#Preview {
  let viewModel = LatestViewModel()
  return ZStack {
    NavigationView {
      LatestView()
    }
  }
  .environmentObject(viewModel)
}
