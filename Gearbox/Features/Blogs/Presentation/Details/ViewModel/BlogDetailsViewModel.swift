//
//  BlogDetailsViewModel.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.02.2025..
//
import SwiftUI

class BlogDetailsViewModel: ObservableObject {
  // MARK: - PROPERTIES
  @Published var state: BlogDetailsState
  
  // MARK: - CONSTRUCTOR
  init(state: BlogDetailsState = BlogDetailsState()) {
    self.state = state
  }
  
  // MARK: - FUNCTIONS
  func select(_ blog: Blog) {
    state.blog = blog
  }
}
