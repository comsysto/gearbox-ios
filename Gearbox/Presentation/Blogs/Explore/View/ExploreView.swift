//
//  ExploreView.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.11.2024..
//
import SwiftUI

struct ExploreView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: ExploreViewModel
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack {
        renderSearchInput()
        
        switch(viewModel.state.searchCategory) {
          case .blog:
            if viewModel.state.isLoading {
              ProgressView()
                .padding()
            } else {
              renderBlogSection()
            }
          case .author:
            if viewModel.state.isLoading {
              ProgressView()
                .padding()
            } else {
              renderUserSection()
            }
        }
        Spacer()
      } //: VSTACK
      .padding(.horizontal, 20)
      .safeAreaInset(edge: .top) {
        renderTitle()
      }
    } //: ZSTACK
  }
  
  // MARK: - FUNCTIONS
  private func searchBlogsAndUsers() {
    if (viewModel.state.searchTerm.isEmpty) {
      viewModel.resetState()
      return
    }
    
    viewModel.searchBlogsOrUsers()
  }
}

// MARK: - VIEW EXTENSIONS
private extension ExploreView {
  @ViewBuilder
  func renderTitle() -> some View {
    HStack {
      Text("label.explore")
        .font(.largeTitle.bold())
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
      Spacer()
    } //: HSTACK
  }
  
  @ViewBuilder
  func renderSearchInput() -> some View {
    VStack {
      GearboxTextField("Search...", text: $viewModel.state.searchTerm, type: .text)
        .onChange(of: viewModel.state.searchTerm) { _, _ in
          searchBlogsAndUsers()
        }
      
      Picker("Search category", selection: $viewModel.state.searchCategory) {
        Text("label.blogs").tag(SearchCateogory.blog)
        Text("label.users").tag(SearchCateogory.author)
      }
      .pickerStyle(SegmentedPickerStyle())
      .onChange(of: viewModel.state.searchCategory) { _, _ in
        viewModel.state.searchTerm = ""
        viewModel.resetState()
      }
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderBlogSection() -> some View {
    switch (viewModel.state.blogSearchResult) {
      case .initial:
        Spacer()
      case .result:
        ScrollView {
          LazyVStack {
            ForEach(0..<viewModel.state.blogResultList.count, id: \.self) { index in
              renderBlogCard(at: index)
            } //: FOR EACH
            
            if viewModel.state.isLoadingMore {
              ProgressView().padding()
            }
          } //: LAZY VSTACK
        } //: SCROLL VIEW
      case .noResult:
        VStack(alignment: .center) {
          Spacer()
          Image(systemName: "newspaper.fill")
            .resizable()
            .frame(width: 45, height: 45)
            .foregroundStyle(.secondary)
            .padding(.bottom, 5)
          Text("explore.label.blog-no-result.title")
            .font(.custom("RobotoCondensed-Bold", size: 22))
          Text("explore.label.blog-no-result.description")
            .font(.callout)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
          Spacer()
        } //: VSTACK
        .frame(maxWidth: .infinity)
      case .error:
        renderErrorMessage()
    }
  }
  
  @ViewBuilder
  func renderBlogCard(at index: Int) -> some View {
    let blog = viewModel.state.blogResultList[index]
    BlogCard(for: blog)
      .onAppear {
        if index == viewModel.state.blogResultList.count - 1 {
          viewModel.searchBlogsOrUsers(loadMore: true)
        }
      }
  }
  
  @ViewBuilder
  func renderUserSection() -> some View {
    switch (viewModel.state.authorSearchResult) {
      case .initial:
        Spacer()
      case .result:
        ScrollView {
          LazyVStack {
            ForEach(0..<viewModel.state.authorResultList.count, id: \.self) { index in
              renderProfileInfo(at: index)
            }
            
            if viewModel.state.isLoadingMore {
              ProgressView().padding()
            }
          } //: LAZY VSTACK
        } //: SCROLL VIEW
      case .noResult:
        VStack(alignment: .center) {
          Spacer()
          Image(systemName: "person.circle")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(.secondary)
          Text("explore.label.user-no-result.title")
            .font(.custom("RobotoCondensed-Bold", size: 22))
          Text("explore.label.user-no-result.description")
            .font(.callout)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
          Spacer()
        } //: VSTACK
        .frame(maxWidth: .infinity)
      case .error:
        renderErrorMessage()
    }
  }
  
  @ViewBuilder
  func renderProfileInfo(at index: Int) -> some View {
    let user = viewModel.state.authorResultList[index]
    HStack {
      Image(systemName: "person.circle.fill") //TODO: Replace with cached image later
        .resizable()
        .frame(width: 50, height: 50)
        .padding(.trailing, 5)
      Text("@\(user.username)")
      Spacer()
    } //: VSTACK
    .padding(.vertical, 5)
    .onAppear {
      if index == viewModel.state.authorResultList.count - 1 {
        viewModel.searchBlogsOrUsers(loadMore: true)
      }
    }
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
      Text("error.unknown")
        .font(.callout)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
      Spacer()
    } //: VSTACK
  }
}

// MARK: - PREVIEW
#Preview("Initial State") {
  let viewModel = ExploreViewModel()
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("Blog - No Result") {
  let viewModel = ExploreViewModel()
  viewModel.state.searchCategory = .blog
  viewModel.state.blogSearchResult = .noResult
  viewModel.state.authorSearchResult = .noResult
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("Blog - Result") {
  let viewModel = ExploreViewModel()
  viewModel.state.blogResultList = mockBlogState()
  viewModel.state.searchCategory = .blog
  viewModel.state.blogSearchResult = .result
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("Blog - Error") {
  let viewModel = ExploreViewModel()
  viewModel.state.searchCategory = .blog
  viewModel.state.blogSearchResult = .error
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("User - No Result") {
  let viewModel = ExploreViewModel()
  viewModel.state.searchCategory = .author
  viewModel.state.authorSearchResult = .noResult
  viewModel.state.blogSearchResult = .noResult
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("User - Result") {
  let viewModel = ExploreViewModel()
  viewModel.state.searchCategory = .author
  viewModel.state.authorSearchResult = .result
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("User - Error") {
  let viewModel = ExploreViewModel()
  viewModel.state.searchCategory = .author
  viewModel.state.authorSearchResult = .error
  
  return ZStack {
    NavigationStack {
      ExploreView()
    }
  }
  .environmentObject(viewModel)
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
