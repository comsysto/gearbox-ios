//
//  MyPaginator.swift
//  Gearbox
//
//  Created by Filip Kisić on 28.04.2025..
//

final class PageController {
  private(set) var currentPage: Int = 0
  private(set) var isLastPage: Bool = false
  let pageSize: Int
  
  init (pageSize: Int = 10) {
    self.pageSize = pageSize
  }
  
  func reset() {
    currentPage = 0
    isLastPage = false
  }
  
  func incrementPage() {
    if !isLastPage {
      currentPage += 1
    }
  }
  
  func setLastPage(_ value: Bool) {
    isLastPage = value
  }
}

struct Paginated<T> {
  let items: [T]
  let isLastPage: Bool
  
  static func empty() -> Paginated<T> {
    Paginated(items: [], isLastPage: true)
  }
}
