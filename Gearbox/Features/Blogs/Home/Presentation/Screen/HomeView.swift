//
//  HomeView.swift
//  Gearbox
//
//  Created by Filip Kisić on 13.08.2024..
//

import SwiftUI

struct HomeView: View {
  // MARK: - PROPERTIES
  @State private var currentTrendingIndex = 0
  
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
  
  init() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.text)
    UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.text).withAlphaComponent(0.2)
  }
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack {
        // MARK: - HEADER
        HStack {
          VStack(alignment: .leading) {
            Text("label.home")
              .font(.largeTitle.bold())
              .foregroundColor(.text)
            
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
          }
        } //: HSTACK
        .padding(.horizontal, 20)
        
        // MARK: - TRENDING LIST
        TabView(selection: $currentTrendingIndex) {
          ForEach(0..<trendingBlogsMock.count, id: \.self) { index in
            TrendingBlogCard(
              imageUrl: trendingBlogsMock[index].imageUrl,
              title: trendingBlogsMock[index].title,
              category: trendingBlogsMock[index].category,
              timePassed: trendingBlogsMock[index].timePassed,
              numOfLikes: trendingBlogsMock[index].numOfLikes
            )
            .padding()
          }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(height: 380)
        .offset(y: -30)
        
        Spacer()
      } //: VSTACK
    } //: ZSTACK
    .navigationBarBackButtonHidden()
  }
}

// MARK: - PREVIEW
#Preview {
  return ZStack {
    NavigationView {
      HomeView()
    }
  }
}

struct MockTrendingBlog {
  let imageUrl: String
  let title: String
  let category: String
  let timePassed: String
  let numOfLikes: Int
}
