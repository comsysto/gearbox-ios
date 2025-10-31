//
//  Comment.swift
//  Gearbox
//
//  Created by Filip Kisić on 29.10.2025..
//
import Foundation

struct Comment: Identifiable, Equatable {
  let id: String
  let blogId: String
  let userId: String
  let username: String
  let profileImageUrl: String?
  let content: String
}
