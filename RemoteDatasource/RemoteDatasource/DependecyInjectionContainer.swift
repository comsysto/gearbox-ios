//
//  DependencyInjectionContainer.swift
//
//
//  Created by Filip Kisić on 06.08.2024..
//

import Foundation
import Dependency

@available(iOS 15.0, *)
public struct AuthenticationDatasourceKey: DependencyKey {
  static public var currentValue: AuthenticationDatasourceType = AuthenticationClient()
}

@available(iOS 15.0, *)
public struct BlogDatasourceKey: DependencyKey {
  static public var currentValue: BlogDatasourceType = BlogClient()
}

@available(iOS 15.0, *)
public struct UserDatasourceKey: DependencyKey {
  static public var currentValue: UserDatasourceType = UserClient()
}

extension DependencyValues {
  @available(iOS 15.0, *)
  public var authenticationDatasourceKey: AuthenticationDatasourceType {
    get { Self[AuthenticationDatasourceKey.self] }
    set { Self[AuthenticationDatasourceKey.self] = newValue }
  }
  
  @available(iOS 15.0, *)
  public var blogDatasourceKey: BlogDatasourceType {
    get { Self[BlogDatasourceKey.self] }
    set { Self[BlogDatasourceKey.self] = newValue }
  }
  
  @available(iOS 15.0, *)
  public var userDatasourceKey: UserDatasourceType {
    get { Self[UserDatasourceKey.self] }
    set { Self[UserDatasourceKey.self] = newValue }
  }
}
