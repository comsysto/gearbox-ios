//
//  File.swift
//
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency

@available(iOS 15.0, *)
public struct AuthenticationDatasourceKey: DependencyKey {
  static public var currentValue: AuthenticationDatasource = AuthenticationClient()
}

@available(iOS 15.0, *)
public struct BlogDatasourceKey: DependencyKey {
  static public var currentValue: BlogDatasource = BlogClient()
}

extension DependencyValues {
  @available(iOS 15.0, *)
  public var authenticationDatasourceKey: AuthenticationDatasource {
    get { Self[AuthenticationDatasourceKey.self] }
    set { Self[AuthenticationDatasourceKey.self] = newValue }
  }
  
  @available(iOS 15.0, *)
  public var blogDatasourceKey: BlogDatasource {
    get { Self[BlogDatasourceKey.self] }
    set { Self[BlogDatasourceKey.self] = newValue }
  }
}
