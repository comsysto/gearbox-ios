//
//  TrendingBlogCard.swift
//  Gearbox
//
//  Created by Filip Kisić on 10.09.2024..
//

import SwiftUI

struct TrendingBlogCard: View {
  // MARK: - PROPERTIES
  let imageUrl: String
  let title: String
  let category: String
  let timePassed: String
  let numOfLikes: Int
  
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        ZStack {
          if let cachedImage = imageCache.load(forKey: imageUrl) {
            Image(uiImage: cachedImage)
              .resizable()
              .scaledToFill()
              .frame(maxWidth: UIScreen.main.bounds.size.width - 60, maxHeight: 200)
              .clipShape(RoundedRectangle(cornerRadius: 5))
          } else {
            Color.gray.opacity(0.3)
              .scaledToFill()
              .frame(maxWidth: UIScreen.main.bounds.size.width - 60, maxHeight: 200)
              .clipShape(RoundedRectangle(cornerRadius: 5))
          }
          
          Text("Trending")
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.brand)
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .offset(x: -120, y: -77)
        } //: ZSTACK
        Text(title)
          .font(Font.custom("RobotoCondensed-Bold", size: 20))
          .frame(width: 323, height: 27, alignment: .leading)
          .truncationMode(.tail)
          .padding(.bottom, 2)
        
        HStack {
          Text(category)
            .font(.caption2)
            .foregroundStyle(.gray)
          
          Spacer()
          
          Image(systemName: "clock")
            .font(.caption)
            .offset(x:5)
            .foregroundStyle(.gray)
          Text(timePassed)
            .font(.caption2)
            .foregroundStyle(.gray)
          
          Image(systemName: "gearshape")
            .font(.caption)
            .offset(x:5)
            .foregroundStyle(.gray)
          Text("\(numOfLikes)")
            .font(.caption2)
            .foregroundStyle(.gray)
        } //: HSTACK
      } //: VSTACK
      .padding()
      .background(Color.background)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .shadow(color: .shadow, radius: 10, y: 5)
    } //: ZSTACK
  }
}

struct ShimmerTrendingBlogCard: View {
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        ShimmerView()
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.size.width - 60, height: 200)
          .cornerRadius(5)
        
        ShimmerView()
          .frame(width: 200, height: 20, alignment: .leading)
          .cornerRadius(5)
          .padding(.bottom, 2)
        
        HStack {
          ShimmerView()
            .frame(width: 75, height: 15)
            .cornerRadius(5)
          
          Spacer()
          
          ShimmerView()
            .frame(width: 80, height: 15)
            .cornerRadius(5)
          Spacer()
            .frame(width: 10)
          ShimmerView()
            .frame(width: 30, height: 15)
            .cornerRadius(5)
        } //: HSTACK
      } //: VSTACK
      .padding()
      .background(Color.background)
      .cornerRadius(8)
      .shadow(color: .shadow, radius: 10, y: 5)
    }
  }
}

// MARK: - PREVIEW
#Preview {
  ZStack {
    Color.background.ignoresSafeArea()
    ShimmerTrendingBlogCard()
    .padding()
  } //: ZSTACK
}
