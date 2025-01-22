//
//  PageableResponse.swift
//  GearboxDatasource
//
//  Created by Filip Kisić on 05.12.2024..
//

public struct PageableResponse<Response: Decodable>: Decodable {
  public let totalElements: Int
  public let totalPages: Int
  public let first: Bool
  public let last: Bool
  public let size: Int
  public let content: Response
}

public struct PageableBlogResponse: Decodable {
  public let totalPages: Int
  public let totalElements: Int
  public let first: Bool
  public let last: Bool
  public let size: Int
  public let content: [BlogResponse]
  public let number: Int
  public let sort: Sort
  public let pageable: Pageable
  public let numberOfElements: Int
  public let empty: Bool
}

public struct Sort: Decodable {
  public let empty: Bool
  public let sorted: Bool
  public let unsorted: Bool
}

public struct Pageable: Decodable {
  public let pageNumber: Int
  public let pageSize: Int
  public let sort: Sort
  public let offset: Int
  public let paged: Bool
  public let unpaged: Bool
}
