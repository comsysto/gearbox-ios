//
//  File.swift
//
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation

@available(iOS 15.0, *)
class AuthenticationClient: AuthenticationDatasourceType {
  
  private let baseUrl = "http://localhost:8080/api/auth"
  
  func signIn(request: SignInRequest) async throws -> AuthenticationResponse {
    return try await executeTheRequest("/signIn", request)
  }
  
  func signUp(request: SignUpRequest) async throws -> AuthenticationResponse {
    return try await executeTheRequest("/signUp", request)
  }
  
  func refreshToken(request: RefreshTokenRequest) async throws -> AuthenticationResponse {
    return try await executeTheRequest("/refreshToken", request)
  }
  
  private func executeTheRequest(_ endpoint: String, _ request: Codable) async throws -> AuthenticationResponse {
    guard let jsonBody = try? JSONEncoder().encode(request) else {
      throw AuthenticationException.invalidRequest("Invalid request.")
    }
    
    let (response, status) = try await sendRequest(endpoint: endpoint, jsonBody: jsonBody)
    
    return try mapResponseToApplicationObject(response, status)
  }
  
  private func sendRequest(endpoint: String, jsonBody: Data) async throws -> (Data, URLResponse){
    let url = URL(string: baseUrl + endpoint)!
    var request = URLRequest(url: url)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = jsonBody
    
    return try await URLSession.shared.data(for: request)
  }
  
  private func mapResponseToApplicationObject(
    _ response: Data,
    _ status: URLResponse
  ) throws -> AuthenticationResponse {
    let httpResponse = status as? HTTPURLResponse
    
    switch httpResponse?.statusCode {
      case 200:
        let decodedResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: response)
        return decodedResponse
      case 400:
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response)
        switch errorResponse.message {
          case "User already exists.":
            throw AuthenticationException.userAlreadyExists("authentication.error.user-already-exists")
          default:
            throw AuthenticationException.serverError(errorResponse.message)
        }
      case 403:
        throw AuthenticationException.expiredToken("Refresh token is expired.")
      case 404:
        throw AuthenticationException.userNotFound("authentication.error.user-not-found")
      default:
        throw AuthenticationException.serverError("error.server-error")
    }
  }
}
