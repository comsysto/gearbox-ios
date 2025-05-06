//
//  UIImageUtils.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.04.2025..
//
import SwiftUI

extension UIImage {
  func compressImage(withHeight height: CGFloat = 200) -> Data? {
    let resizedImage = self.aspectFittedToHeight(to: height)
    return resizedImage.jpegData(compressionQuality: 0.4)
  }
  
  private func aspectFittedToHeight(to newHeight: CGFloat) -> UIImage {
    let scale = newHeight / self.size.height
    let newWidth = self.size.width * scale
    let newSize = CGSize(width: newWidth, height: newHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
}
