//
//  BlogCard.swift
//  Gearbox
//
//  Created by Filip Kisić on 22.11.2024..
//

import SwiftUI

struct BlogCard: View {
  // MARK: - PROPERTIES
  let imageUrl: String
  let title: String
  let category: String
  let timePassed: String
  let numOfLikes: Int
  
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  // MARK: - BODY
  var body: some View {
    HStack {
      VStack (alignment: .leading) {
        
        Text(category)
          .font(.caption)
          .foregroundStyle(.gray)
        Text(title)
          .font(Font.custom("RobotoCondensed-Medium", size: 16))
          .truncationMode(.tail)
          .padding(.bottom, 7)
          .padding(.top, 2)
        HStack {
          Image(systemName: "clock")
            .font(.caption)
            .foregroundStyle(.gray)
          Text(timePassed)
            .font(.caption2)
            .foregroundStyle(.gray)
            .offset(x:-5)
          
          Image(systemName: "gearshape")
            .font(.caption)
            .offset(x:5)
            .foregroundStyle(.gray)
          Text("\(numOfLikes)")
            .font(.caption2)
            .foregroundStyle(.gray)
        } //: HSTACK
      } //: VSTACK
      Spacer()
    
      if let cachedImage = imageCache.load(forKey: imageUrl) {
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
  return ZStack {
    Color.background.ignoresSafeArea()
    VStack {
      BlogCard(
        imageUrl: "trending_placeholder",
        title: "Next generation Apple Car Play integration started",
        category: "Technology",
        timePassed: "30 min ago",
        numOfLikes: 13
      )
      ShimmerBlogCard()
    } //: VSTACK
    .padding()
  }
}
