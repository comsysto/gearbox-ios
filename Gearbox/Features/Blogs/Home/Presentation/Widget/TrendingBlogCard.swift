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
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        ZStack {
          AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
          } placeholder: {
            Color.gray.opacity(0.3)
          }
          .scaledToFill()
          .frame(maxWidth: UIScreen.main.bounds.size.width - 60, maxHeight: 200)
          .clipShape(RoundedRectangle(cornerRadius: 5))
          
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

// MARK: - PREVIEW
#Preview {
  ZStack {
    Color.background.ignoresSafeArea()
    TrendingBlogCard(
      imageUrl: "trending_placeholder",
      title: "BMW released a new concept car",
      category: "Concepts",
      timePassed: "1 day ago",
      numOfLikes: 69
    )
    .padding()
  } //: ZSTACK
}
