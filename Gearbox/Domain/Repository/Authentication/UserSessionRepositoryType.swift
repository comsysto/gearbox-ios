//
//  SessionManagerType.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.04.2025..
//

protocol UserSessionRepositoryType {
  func saveSession(_ session: UserSession)
  func getSession() -> UserSession
  func clearSession()
}
