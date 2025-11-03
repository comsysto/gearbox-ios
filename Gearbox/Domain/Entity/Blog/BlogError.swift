//
//  BlogError.swift
//  Gearbox
//
//  Created by Filip Kisić on 05.12.2024..
//

enum BlogError: Error, Equatable {
  case serverError(_ message: String)
}
