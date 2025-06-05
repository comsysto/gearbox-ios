//
//  ProfileBlogListView.swift
//  Gearbox
//
//  Created by Filip Kisić on 02.06.2025..
//

import SwiftUI

struct ProfileBlogListView: View {
  var blogs: [Blog]
  var isLoading: Bool
  var errorMessage: String?
  var emptyStateConfig: EmptyStateConfig?
  
  var body: some View {
    if isLoading {
      renderLoadingState()
    } else if errorMessage != nil {
      renderErrorMessage()
    } else if blogs.isEmpty {
      renderEmptyState()
    } else {
      renderBlogList()
    }
  }
}

private extension ProfileBlogListView {
  @ViewBuilder
  func renderLoadingState() -> some View {
    VStack {
      ShimmerBlogCard()
        .frame(height: 120)
      ShimmerBlogCard()
        .frame(height: 120)
      ShimmerBlogCard()
        .frame(height: 120)
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderErrorMessage() -> some View {
    VStack(alignment: .center) {
      Spacer()
      Image(systemName: "xmark.octagon")
        .resizable()
        .frame(width: 45, height: 45)
        .foregroundStyle(.error)
        .padding(.bottom, 5)
      Text("error.title")
        .font(.custom("RobotoCondensed-Bold", size: 22))
      Text(LocalizedStringKey(errorMessage!))
        .font(.callout)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
      Spacer()
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderEmptyState() -> some View {
    switch (emptyStateConfig) {
      case .postedBlogs:
        VStack(alignment: .center) {
          Spacer()
          Image(systemName: "newspaper.fill")
            .resizable()
            .frame(width: 45, height: 45)
            .foregroundStyle(.secondary)
            .padding(.bottom, 5)
          Text("profile.label.posted-blogs-empty.title")
            .font(.custom("RobotoCondensed-Bold", size: 22))
          Text("profile.label.posted-blogs-empty.description")
            .font(.callout)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
          Spacer()
        } //: VSTACK
        .frame(maxWidth: .infinity)
      case .likedBlogs:
        VStack(alignment: .center) {
          Spacer()
          Image(systemName: "newspaper.fill")
            .resizable()
            .frame(width: 45, height: 45)
            .foregroundStyle(.secondary)
            .padding(.bottom, 5)
          Text("profile.label.liked-blogs-empty.title")
            .font(.custom("RobotoCondensed-Bold", size: 22))
          Text("profile.label.liked-blogs-empty.description")
            .font(.callout)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
          Spacer()
        } //: VSTACK
        .frame(maxWidth: .infinity)
      case .none:
        EmptyView()
    }
  }
  
  @ViewBuilder
  func renderBlogList() -> some View {
    ScrollView {
      LazyVStack {
        ForEach(blogs) { blog in
          BlogCard(for: blog)
        } //: FOR EACH
      } //: LAZY VSTACK
    } //: SCROLL VIEW
  }
}

enum EmptyStateConfig {
  case postedBlogs, likedBlogs
}

#Preview("Loading") {
  let blogs: [Blog] = []
  let isLoading: Bool = true
  let errorMessage: String? = nil
  let isEmpty: Bool = false
  let emptyStateConfig: EmptyStateConfig? = .postedBlogs
  
  ZStack {
    ProfileBlogListView(blogs: blogs, isLoading: isLoading)
  }
  .padding(.horizontal, 20)
}

#Preview("Empty my blogs") {
  let blogs: [Blog] = []
  let isLoading: Bool = false
  let errorMessage: String? = nil
  let isEmpty: Bool = true
  let emptyStateConfig: EmptyStateConfig? = .postedBlogs
  
  ZStack {
    ProfileBlogListView(
      blogs: blogs,
      isLoading: isLoading,
      emptyStateConfig: emptyStateConfig
    )
  }
  .padding(.horizontal, 20)
}

#Preview("Empty liked blogs") {
  let blogs: [Blog] = []
  let isLoading: Bool = false
  let errorMessage: String? = nil
  let isEmpty: Bool = true
  let emptyStateConfig: EmptyStateConfig? = .likedBlogs
  
  ZStack {
    ProfileBlogListView(
      blogs: blogs,
      isLoading: isLoading,
      emptyStateConfig: emptyStateConfig
    )
  }
  .padding(.horizontal, 20)
}

#Preview("Error") {
  let blogs: [Blog] = []
  let isLoading: Bool = false
  let errorMessage: String? = "Something went wrong."
  let isEmpty: Bool = false
  let emptyStateConfig: EmptyStateConfig? = .likedBlogs
  
  ZStack {
    ProfileBlogListView(
      blogs: blogs,
      isLoading: isLoading,
      errorMessage: errorMessage,
      emptyStateConfig: emptyStateConfig
    )
  }
  .padding(.horizontal, 20)
}

#Preview("Filled") {
  let blogs: [Blog] = mockBlogState()
  let isLoading: Bool = false
  let errorMessage: String? = nil
  let isEmpty: Bool = false
  let emptyStateConfig: EmptyStateConfig? = nil
  
  ZStack {
    ProfileBlogListView(
      blogs: blogs,
      isLoading: isLoading,
      errorMessage: errorMessage,
      emptyStateConfig: emptyStateConfig
    )
  }
  .padding(.horizontal, 20)
}

private func mockBlogState() -> [Blog] {
  return [
    Blog(
      id: "1",
      title: "Blog #1",
      content: "Content #1",
      thumbnailImageUrl: "photo_icon",
      createDate: Date(),
      numberOfLikes: 13,
      category: "Technology",
      author: Author(id: "1", username: "@filipkisic", profileImageUrl: "photo_icon")
    ),
    Blog(
      id: "2",
      title: "Blog #2",
      content: "Content #2",
      thumbnailImageUrl: "photo_icon",
      createDate: Date(),
      numberOfLikes: 15,
      category: "Old Timer",
      author: Author(id: "1", username: "@filipkisic", profileImageUrl: "photo_icon")
    ),
    Blog(
      id: "3",
      title: "Blog #3",
      content: "Content #3",
      thumbnailImageUrl: "photo_icon",
      createDate: Date(),
      numberOfLikes: 3,
      category: "Concept",
      author: Author(id: "1", username: "@filipkisic", profileImageUrl: "photo_icon")
    ),
  ]
}
