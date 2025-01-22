//
//  HomeView.swift
//  Gearbox
//
//  Created by Filip Kisić on 13.08.2024..
//

import SwiftUI

struct HomeView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: HomeViewModel
  
  private let trendingBlogsMock = [
    MockTrendingBlog(
      imageUrl: "trending_placeholder",
      title: "BMW released a new concept car",
      category: "Concepts",
      timePassed: "1 day ago",
      numOfLikes: 69
    ),
    MockTrendingBlog(
      imageUrl: "trending_placeholder",
      title: "BMW Touring Coupe concept",
      category: "Concepts",
      timePassed: "2 days ago",
      numOfLikes: 13
    ),
    MockTrendingBlog(
      imageUrl: "trending_placeholder",
      title: "One of a kind tribute",
      category: "Concepts",
      timePassed: "46 min ago",
      numOfLikes: 2
    ),
  ]
  
  private let latestBlogsMock = [
    MockTrendingBlog(
      imageUrl: "trending_placeholder",
      title: "Next generation Apple Car Play integration started",
      category: "Technology",
      timePassed: "30 min ago",
      numOfLikes: 3
    ),
    MockTrendingBlog(
      imageUrl: "trending_placeholder",
      title: "GTI Clubsport confirmed as the Most Powerful FWD Golf",
      category: "Hot news",
      timePassed: "47 min ago",
      numOfLikes: 11
    ),
    MockTrendingBlog(
      imageUrl: "trending_placeholder",
      title: "Kia confirms EV3 is coming to the market in 2025",
      category: "Electric cars",
      timePassed: "52 min ago",
      numOfLikes: 13
    ),
  ]
  
  init() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.text)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.text).withAlphaComponent(0.2)
  }
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      ScrollView {
          renderTrendingBlogs()
          renderLatestBlogs()
            .padding(.horizontal, 20)
      } //: SCROLL VIEW
      .safeAreaInset(edge: .top) {
        renderNavigationBar()
      }
      .navigationBarHidden(true)
      .scrollIndicators(.hidden)
    } //: ZSTACK
    .onAppear {
      viewModel.getTrendingBlogs()
    }
    .onChange(of: viewModel.state.isLoading, perform: handleStateChange)
    .navigationBarBackButtonHidden()
  }
  
  // MARK: - FUNCTIONS
  private func handleStateChange(isLoading: Bool) {
    if isLoading {
      //toggle loading icon on trending blogs
    }
  }
}

private extension HomeView {
  @ViewBuilder
  func renderNavigationBar() -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text("label.home")
          .font(.largeTitle.bold())
        
        Text(DateTimeUtils.getFormattedDay())
          .font(.caption2)
          .foregroundColor(.gray)
      }
      Spacer()
      NavigationLink {
        Text("Notifications")
      } label: {
        Image(systemName: "bell.badge")
          .font(.title2)
          .foregroundColor(.text)
          .padding(5)
          .overlay {
            Circle()
              .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
          }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(Color.background.opacity(0.2).overlay(.ultraThinMaterial))
  }
  
  @ViewBuilder
  func renderTrendingBlogs() -> some View {
    if viewModel.state.isLoading {
      ProgressView()
    } else {
      TabView(selection: $viewModel.state.currentTrendingBlogIndex) {
        ForEach(0..<viewModel.state.trendingBlogs.count, id: \.self) { index in
          renderTrendingCard(at: index)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
      .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
      .frame(height: 380)
      .offset(y: -50)
    }
  }
  
  @ViewBuilder
  func renderTrendingCard(at index: Int) -> some View {
    let blog = viewModel.state.trendingBlogs[index]
    TrendingBlogCard(
      imageUrl: blog.thumbnailImageUrl,
      title: blog.title,
      category: blog.category,
      timePassed: blog.createDate.ISO8601Format(),
      numOfLikes: blog.numberOfLikes
    )
    .padding(.horizontal, 20)
  }
  
  @ViewBuilder
  func renderLatestBlogs() -> some View {
    VStack {
      HStack {
        Text("label.latest")
          .font(.custom("RobotoCondensed-Bold", size: 16))
        Spacer()
        Text("label.view-more")
          .font(.caption)
          .foregroundStyle(.brand)
      } //: HSTACK
      ForEach(0..<latestBlogsMock.count, id: \.self) { index in
        BlogCard(
          imageUrl: latestBlogsMock[index].imageUrl,
          title: latestBlogsMock[index].title,
          category: latestBlogsMock[index].category,
          timePassed: latestBlogsMock[index].timePassed,
          numOfLikes: latestBlogsMock[index].numOfLikes
        )
        .frame(height: 120)
      }
    } //: VSTACK
    .offset(y: -70)
  }
}

// MARK: - PREVIEW
#Preview {
  let viewModel = HomeViewModel()
  return ZStack {
    NavigationView {
      HomeView()
    }
  }
  .environmentObject(viewModel)
}
