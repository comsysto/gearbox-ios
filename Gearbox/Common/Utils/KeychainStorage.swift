//
//  AppSecureStorage.swift
//  Gearbox
//
//  Created by Filip Kisić on 14.08.2024..
//

import Foundation
import KeychainSwift

@propertyWrapper
struct KeychainStorage {
  private let keychain: KeychainSwift
  private let key: String
  
  init(_ key: String) {
    self.keychain = KeychainSwift()
    self.key = key
  }
  
  var wrappedValue: String {
    get {
      keychain.get(key) ?? ""
    }
    
    nonmutating set {
      keychain.set(newValue, forKey: key)
    }
  }
}

