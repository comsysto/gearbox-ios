//
//  BlogResponseToBlogEntityConverter.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
import GearboxDatasource

class BlogResponseToBlogEntityConverter: ConverterType {
  typealias Source = BlogResponse
  typealias Target = Blog
  
  func convert(_ response: BlogResponse) -> Blog {
    return Blog(
      id: response.id,
      title: response.title,
      content: response.content,
      thumbnailImageUrl: response.thumbnailImageUrl,
      createDate: response.createDate,
      numberOfLikes: response.numberOfLikes,
      category: response.category,
      author: Author(
        id: response.author.id,
        username: response.author.username,
        profileImageUrl: response.author.profileImageUrl
      )
    )
  }
}
