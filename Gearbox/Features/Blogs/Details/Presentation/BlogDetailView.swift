//
//  BlogDetailView.swift
//  Gearbox
//
//  Created by Filip Kisić on 26.11.2024..
//

import SwiftUI

struct BlogDetailView: View {
  // MARK: - PROPERTIES
  let blog: MockTrendingBlog
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      ScrollView {
        VStack(alignment: .leading) {
          renderUser()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
          renderBlogHeader()
            .padding(.horizontal, 20)
          renderBlogContent()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
          //renderBottomActions()
        }
      } //: SCROLL VIEW
      .scrollIndicators(.hidden)
      .safeAreaInset(edge: .top) {
        renderNavigationBar()
      }
    } //: ZSTACK
    .navigationBarBackButtonHidden(true)
  }
}

private extension BlogDetailView {
  @ViewBuilder
  func renderNavigationBar() -> some View {
    HStack {
      Image(systemName: "arrow.left")
        .resizable()
        .scaledToFit()
        .frame(width: 22)
        .foregroundStyle(.text)
      Text("label.back")
        .font(.footnote)
      Spacer()
    } //: HSTACK
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(Color.background.opacity(0.2).overlay(.ultraThinMaterial))
  }
  
  @ViewBuilder
  func renderUser() -> some View {
    HStack {
      Image("trending_placeholder")
        .resizable()
        .scaledToFit()
        .frame(width: 50)
        .clipShape(Circle())
      Text("@brunobenner")
        .font(.caption)
        .foregroundStyle(.gray)
      Spacer()
    } //: HSTACK
  }
  
  @ViewBuilder
  func renderBlogHeader() -> some View {
    VStack(alignment: .leading) {
      Text(blog.title)
        .font(Font.custom("RobotoCondensed-Bold", size: 28))
        .frame(maxWidth: 353, maxHeight: 70, alignment: .leading)
        .truncationMode(.tail)
        .padding(.bottom, 15)
      Image(blog.imageUrl)
        .resizable()
        .scaledToFill()
        .frame(maxHeight: 200)
        .clipShape(RoundedRectangle(cornerRadius: 5))
      HStack {
        Image(systemName: "clock")
          .font(.caption)
          .offset(x:5)
          .foregroundStyle(.gray)
        Text(blog.timePassed)
          .font(.caption2)
          .foregroundStyle(.gray)
        
        Spacer()
          .frame(width: 30)
        
        Text(blog.category)
          .font(.caption2)
          .foregroundStyle(.gray)
      } //: HSTACK
      .padding(.top, 5)
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderBlogContent() -> some View {
    Text("Next-generation CarPlay will have deeper integration with a vehicle's instrument cluster, climate controls, FM radio, and more. It will also support multiple displays across the dashboard, and offer a variety of personalization options.\n\nAston Martin and Porsche previewed their customized next-generation CarPlay designs in December. Aston Martin said it would release its first vehicles with next-generation CarPlay support in 2024, including a new model of its high-end DB12 sports car. Porsche did not provide a timeframe or specific details about its own plans.\n\nA spokesperson for Porsche this week told us that it has no update to provide about next-generation CarPlay availability at this time, while a spokesperson for Aston Martin has yet to respond to our request for comment. In January, Apple updated its website to confirm that the first vehicle models with support for next-generation CarPlay will debut in 2024, but it has yet to provide a more specific timeframe. This wording is shown on Apple's websites for several countries, including the U.S., Canada, Australia, New Zealand, and others.")
      .font(.system(size: 14))
      .multilineTextAlignment(.leading)
  }
}

// MARK: - PREVIEW
#Preview {
  let blog = MockTrendingBlog(
    imageUrl: "trending_placeholder",
    title: "Next generation Apple Car Play integration started",
    category: "Concepts",
    timePassed: "1 day ago",
    numOfLikes: 69
  )
  return BlogDetailView(blog: blog)
}

struct MockTrendingBlog {
  let imageUrl: String
  let title: String
  let category: String
  let timePassed: String
  let numOfLikes: Int
}
