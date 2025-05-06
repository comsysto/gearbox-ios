//
//  CacheNewImagesUseCase.swift
//  Gearbox
//
//  Created by Filip Kisić on 19.02.2025..
//
import SwiftUI

class CacheNewImagesUseCase {
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  func execute(for blogs: [Blog]) async {
    for blog in blogs {
      if imageCache.load(forKey: blog.thumbnailImageUrl) == nil {
        await downloadImageFromUrlWithFallbackImage(blog.thumbnailImageUrl)
      }
    }
  }
  
  private func downloadImageFromUrlWithFallbackImage(_ imageUrl: String) async {
    guard let url = URL(string: imageUrl) else { return }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        imageCache.save(image, forKey: imageUrl)
      }
    } catch {
      let image = UIImage(named: "photo_icon")!
      imageCache.save(image, forKey: imageUrl)
    }
  }
}
