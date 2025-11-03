//
//  Blog.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation

struct Blog: Identifiable, Equatable {
  let id: String
  let title: String
  let content: String
  let thumbnailImageUrl: String
  let createDate: Date
  let numberOfLikes: Int
  let category: String
  let author: Author
}
