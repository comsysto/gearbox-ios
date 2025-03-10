//
//  BlogCard.swift
//  Gearbox
//
//  Created by Filip Kisić on 22.11.2024..
//

import SwiftUI

struct BlogCard: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var detailsViewModel: BlogDetailsViewModel
  
  let blog: Blog
  
  // MARK: - CONSTRUCTOR
  init(for blog: Blog) {
    self.blog = blog
  }
  
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  // MARK: - BODY
  var body: some View {
    HStack {
      VStack (alignment: .leading) {
        
        Text(blog.category)
          .font(.caption)
          .foregroundStyle(.gray)
        Text(blog.title)
          .font(Font.custom("RobotoCondensed-Medium", size: 16))
          .truncationMode(.tail)
          .padding(.bottom, 7)
          .padding(.top, 2)
        HStack {
          Image(systemName: "clock")
            .font(.caption)
            .foregroundStyle(.gray)
          Text(blog.createDate.formatAsTimePassed())
            .font(.caption2)
            .foregroundStyle(.gray)
            .offset(x:-5)
          
          Image(systemName: "gearshape")
            .font(.caption)
            .offset(x:5)
            .foregroundStyle(.gray)
          Text("\(blog.numberOfLikes)")
            .font(.caption2)
            .foregroundStyle(.gray)
        } //: HSTACK
      } //: VSTACK
      Spacer()
    
      if let cachedImage = imageCache.load(forKey: blog.thumbnailImageUrl) {
        Image(uiImage: cachedImage)
          .resizable()
          .scaledToFill()
          .frame(width: 90, height: 80)
          .clipShape(RoundedRectangle(cornerRadius: 5))
      } else {
        Image("photo_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 90, height: 80)
          .clipShape(RoundedRectangle(cornerRadius: 5))
      }
    } //: HSTACK
    .padding()
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: .shadow, radius: 10, y: 5)
    .onTapGesture {
      detailsViewModel.select(blog)
      router.navigateTo(.details)
    }
  }
}

// MARK: - SHIMMER
struct ShimmerBlogCard: View {
  var body: some View {
    HStack {
      VStack (alignment: .leading) {
        ShimmerView()
          .frame(width: 70, height: 10)
          .cornerRadius(2)
        ShimmerView()
          .frame(width: 200, height: 30)
          .cornerRadius(5)
        
        HStack {
          ShimmerView()
            .frame(width: 80, height: 10)
            .cornerRadius(2)
          ShimmerView()
            .frame(width: 30, height: 10)
            .cornerRadius(2)
        } //: HSTACK
      } //: VSTACK
      Spacer()
      ShimmerView()
        .frame(width: 90, height: 80)
        .cornerRadius(5)
    } //: HSTACK
    .padding()
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: .shadow, radius: 10, y: 5)
  }
}

// MARK: - PREVIEW
#Preview {
  var router = Router()
  var viewModel = BlogDetailsViewModel()
  let blog = Blog(
    id: "",
    title: "Next generation Apple Car Play integration started",
    content: "",
    thumbnailImageUrl: "trending_placeholder",
    createDate: Date().addingTimeInterval(-3600),
    numberOfLikes: 13,
    category: "Technology",
    author: Author(id: "", username: "filipkisic", profileImageUrl: nil)
  )
  ZStack {
    Color.background.ignoresSafeArea()
    VStack {
      BlogCard(for: blog)
      ShimmerBlogCard()
    } //: VSTACK
    .padding()
    .environmentObject(router)
    .environmentObject(viewModel)
  }
}
