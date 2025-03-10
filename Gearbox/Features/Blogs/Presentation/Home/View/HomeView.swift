//
//  HomeView.swift
//  Gearbox
//
//  Created by Filip Kisić on 13.08.2024..
//

import SwiftUI

struct HomeView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var homeViewModel: HomeViewModel
  @EnvironmentObject private var latestViewModel: LatestViewModel
  @EnvironmentObject private var router: Router
  
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
      homeViewModel.getTrendingBlogs()
      latestViewModel.getLatestBlogs()
    }
    .navigationBarBackButtonHidden()
  }
}

private extension HomeView {
  @ViewBuilder
  func renderNavigationBar() -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text("label.home")
          .font(.largeTitle.bold())
        
        Text(DateTimeUtils.formatAsFullDay())
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
    if homeViewModel.state.isTrendingLoading {
      ShimmerTrendingBlogCard()
        .frame(height: 380)
        .offset(y: -50)
        .padding(.horizontal, 20)
    } else {
      TabView(selection: $homeViewModel.state.currentTrendingBlogIndex) {
        ForEach(0..<homeViewModel.state.trendingBlogs.count, id: \.self) { index in
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
    let blog = homeViewModel.state.trendingBlogs[index]
    TrendingBlogCard(
      imageUrl: blog.thumbnailImageUrl,
      title: blog.title,
      category: blog.category,
      timePassed: blog.createDate.formatAsTimePassed(),
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
          .onTapGesture {
            router.navigateTo(.latest)
          }
      } //: HSTACK
      if latestViewModel.state.isLoading {
        ShimmerBlogCard()
          .frame(height: 120)
        ShimmerBlogCard()
          .frame(height: 120)
        ShimmerBlogCard()
          .frame(height: 120)
      } else {
        ForEach(0..<3, id: \.self) { index in
          renderBlogCard(at: index)
        }
      }
    } //: VSTACK
    .offset(y: -70)
  }
  
  @ViewBuilder
  func renderBlogCard(at index: Int) -> some View {
    let blog = latestViewModel.state.latestBlogs[index]
    BlogCard(for: blog)
      .frame(height: 120)
  }
}

// MARK: - PREVIEW
#Preview {
  let viewModel = HomeViewModel()
  viewModel.state.isTrendingLoading = false
  return ZStack {
    NavigationView {
      HomeView()
    }
  }
  .environmentObject(viewModel)
}
