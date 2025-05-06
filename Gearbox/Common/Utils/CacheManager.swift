//
//  CacheManager.swift
//  Gearbox
//
//  Created by Filip Kisić on 24.01.2025..
//
import UIKit
import SwiftUI

protocol ImageCacheManagerType {
  func save(_ image: UIImage, forKey key: String)
  func load(forKey key: String) -> UIImage?
}

class ImageNSCacheManager: ImageCacheManagerType {
  static let shared = ImageNSCacheManager()
  
  private let imageCache: NSCache<NSString, UIImage> = {
    let cache = NSCache<NSString, UIImage>()
    cache.countLimit = 100
    return cache
  }()
  
  // MARK: - CONSTRUCTOR
  private init() {}
  
  // MARK: - FUNCTIONS
  func save(_ image: UIImage, forKey key: String) {
    imageCache.setObject(image, forKey: key as NSString)
  }
  
  func load(forKey key: String) -> UIImage? {
    return imageCache.object(forKey: key as NSString)
  }
}
