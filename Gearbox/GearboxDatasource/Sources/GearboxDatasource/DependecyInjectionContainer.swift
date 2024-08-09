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

extension DependencyValues {
  @available(iOS 15.0, *)
  public var authenticationDatasource: AuthenticationDatasource {
    get { Self[AuthenticationDatasourceKey.self] }
    set { Self[AuthenticationDatasourceKey.self] = newValue }
  }
}
