//
//  File.swift
//
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation

@available(iOS 15.0, *)
class AuthenticationClient: AuthenticationDatasource {
  
  private let baseUrl = "http://localhost:8080/api/auth"
  
  func signIn(request: SignInRequest) async throws -> AuthenticationResponse {
    guard let jsonBody = try? JSONEncoder().encode(request) else {
      throw AuthenticationException.invalidRequest("Invalid sign in data.")
    }
    
    let url = URL(string: "\(baseUrl)/signIn")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = jsonBody
    
    let (response, status) = try await URLSession.shared.data(for: request)
    
    return try mapResponseToApplicationObject(response, status)
  }
  
  func signUp(request: SignUpRequest) async throws -> AuthenticationResponse {
    guard let jsonBody = try? JSONEncoder().encode(request) else {
      throw AuthenticationException.invalidRequest("Invalid request.")
    }
    
    let url = URL(string: "\(baseUrl)/signUp")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = jsonBody
    
    let (response, status) = try await URLSession.shared.data(for: request)
    
    return try mapResponseToApplicationObject(response, status)
  }
  
  private func mapResponseToApplicationObject(_ response: Data, _ status: URLResponse) throws -> AuthenticationResponse {
    let httpResponse = status as? HTTPURLResponse
    
    switch httpResponse?.statusCode {
      case 200:
        let decodedResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: response)
        return decodedResponse
      case 400:
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response)
        throw errorResponse.filterException()
      case 404:
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response)
        throw AuthenticationException.userNotFound("authentication.error.user-not-found")
      default:
        throw AuthenticationException.serverError("error.server-error.")
    }
  }
}
